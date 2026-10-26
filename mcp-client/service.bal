import ballerina/http;
import ballerina/log;
import ballerina/time;
import balMCPClient.gemini;
import ballerina/mcp;
import balMCPClient.tools;

// ============================================================================
// CONFIGURATION & CONSTANTS
// ============================================================================

configurable string geminiAPIKey = ?;
configurable string geminiModel = ?;
configurable string mcpEndpoint = ?;

// ============================================================================
// TYPES & DATA STRUCTURES
// ============================================================================

type ChatRequest record {
    string message;
};

type ChatResponse record {
    string message;
};

// ============================================================================
// GLOBAL STATE
// ============================================================================

// Debug counter for request numbering
int requestCounter = 0;

// Conversation history storage - simple in-memory approach
gemini:Content[] globalConversationHistory = [];

// Global clients
gemini:Client? geminiClient = ();
mcp:StreamableHttpClient? mcpClient = ();
gemini:Tool? geminiTools = ();



// ============================================================================
// HTTP SERVICE DEFINITION
// ============================================================================

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        allowHeaders: ["*"],
        allowMethods: ["*"]
    }
}
service / on new http:Listener(8080) {
    
    // Initialize clients when service starts
    function init() returns error? {
        log:printInfo("Starting Ballerina MCP Client Service...");
        check initializeClients();
        log:printInfo("Service initialized successfully!");
    }

    // Chat endpoint
    resource function post chat(ChatRequest chatRequest) returns http:Ok|http:BadRequest|http:InternalServerError {
        log:printInfo("Received chat request: " + chatRequest.message);
        
        // Validate request
        if chatRequest.message.trim() == "" {
            return <http:BadRequest>{ body: "Message cannot be empty" };
        }
        
        // Execute conversation and return response
        ChatResponse|error result = executeConversationFlow(chatRequest.message);
        if result is error {
            log:printError("Error processing chat request: " + result.message());
            return <http:InternalServerError>{ body: "Failed to process request: " + result.message() };
        }
        
        return <http:Ok>{ body: result };
    }
    
    // Handle CORS preflight requests for chat endpoint
    resource function options chat() returns http:Ok {
        return <http:Ok>{
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Methods": "POST, OPTIONS",
                "Access-Control-Allow-Headers": "Content-Type, Accept",
                "Access-Control-Allow-Credentials": "true"
            }
        };
    }
    
    // Health check
    resource function get health() returns json {
        json healthStatus = {
            "status": "healthy",
            "service": "Ballerina MCP Client",
            "timestamp": time:utcNow(),
            "endpoints": {
                "chat": "POST /chat",
                "health": "GET /health"
            },
            "clients": {
                "gemini": geminiClient is () ? "not_initialized" : "initialized",
                "mcp": mcpClient is () ? "not_initialized" : "initialized",
                "tools": geminiTools is () ? "not_loaded" : "loaded"
            }
        };
        
        return healthStatus;
    }
}

// ============================================================================
// CLIENT MANAGEMENT FUNCTIONS
// ============================================================================

// Helper functions
function getTestApiKeysConfig() returns gemini:ApiKeysConfig {
    return {
        xGoogApiKey: geminiAPIKey
    };
}

function getTestGeminiModel() returns string {
    return geminiModel;
}

function getMcpEndpoint() returns string {
    return mcpEndpoint;
}

// Initialize clients
function initializeClients() returns error? {
    log:printInfo("Initializing Gemini client...");
    
    // Setup Gemini Client
    gemini:ApiKeysConfig apiKeysConfig = getTestApiKeysConfig();
    geminiClient = check new (apiKeysConfig);
    
    log:printInfo("Initializing MCP client...");
    
    // Setup MCP Client
    mcp:StreamableHttpClient mcpClientInstance = check new (getMcpEndpoint());
    check mcpClientInstance->initialize({
        "name": "gemini",
        "version": "v1"
    });

    // List available tools
    mcp:ListToolsResult toolsResult = check mcpClientInstance->listTools();
    
    gemini:FunctionDeclaration[] functionDeclarations = [];
    foreach mcp:ToolDefinition tool in toolsResult.tools {
        gemini:FunctionDeclaration functionDecl = tools:convertMcpToolToGeminiFunctionDeclaration(tool);
        functionDeclarations.push(functionDecl);
    }

    geminiTools = {
        functionDeclarations: functionDeclarations
    };
    
    mcpClient = mcpClientInstance;
    
    log:printInfo("Clients initialized successfully with " + functionDeclarations.length().toString() + " tools");
}

// ============================================================================
// BUSINESS LOGIC FUNCTIONS
// ============================================================================

// Execute conversation flow and return final response
function executeConversationFlow(string userMessage) returns ChatResponse|error {
    // Check if clients are initialized
    if geminiClient is () {
        return error("Gemini client not initialized");
    }
    if mcpClient is () {
        return error("MCP client not initialized");
    }
    if geminiTools is () {
        return error("Tools not initialized");
    }
    
    // Cast to non-null types
    gemini:Client geminiClientInstance = <gemini:Client>geminiClient;
    mcp:StreamableHttpClient mcpClientInstance = <mcp:StreamableHttpClient>mcpClient;
    gemini:Tool geminiToolsInstance = <gemini:Tool>geminiTools;
    
    // Add new user message to conversation history
    gemini:Content newUserMessage = {
        parts: [{ text: userMessage }],
        role: "user"
    };
    globalConversationHistory.push(newUserMessage);
    
    // Use the complete conversation history
    gemini:Content[] conversationContents = globalConversationHistory.clone();
    
    // Create system instruction from prompt
    gemini:Content systemInstruction = {
        parts: [
            {
                text: tools:systemPrompt
            }
        ]
    };
    
    // Create the initial GenerateContentRequest with tools and system instruction
    gemini:GenerateContentRequest request = {
        model: getTestGeminiModel(),
        systemInstruction: systemInstruction,
        contents: conversationContents,
        tools: [geminiToolsInstance]
    };

    // Make the API call
    gemini:GenerateContentResponse response = check geminiClientInstance->generativeServiceGenerateModelContent(
        getTestGeminiModel(), request
    );
    
    // Process the response and handle any function calls
    var result = check tools:executeConversationTurn(
        response, 
        mcpClientInstance, 
        geminiClientInstance, 
        conversationContents, 
        geminiToolsInstance, 
        getTestGeminiModel()
    );
    
    // Update global conversation history with the complete result
    globalConversationHistory = result.contents.clone();
    
    // Extract text response
    string responseText = "";
    foreach gemini:Part part in result.finalResponse.parts {
        string? text = part.text;
        if text is string {
            responseText += text;
        }
    }
    
    // Return final response
    return {
        message: responseText
    };
}

// ============================================================================
// DEBUG FUNCTIONS (COMMENTED OUT)
// ============================================================================

// Debug function to dump Gemini request as JSON
// function dumpGeminiRequest(gemini:GenerateContentRequest request) {
//     requestCounter += 1;
//     string fileName = string `httpTrace/gemini_req_${requestCounter}.json`;
    
//     do {
//         json requestJson = request.toJson();
//         check io:fileWriteJson(fileName, requestJson);
//         log:printInfo(string `Debug: Dumped Gemini request to ${fileName}`);
//     } on fail error e {
//         log:printError(string `Failed to dump request: ${e.message()}`);
//     }
// }

// Debug function to dump conversation history
// function dumpConversationHistory() {
//     string fileName = string `httpTrace/conversation_history_${requestCounter}.json`;
    
//     do {
//         json historyJson = globalConversationHistory.toJson();
//         check io:fileWriteJson(fileName, historyJson);
//         log:printInfo(string `Debug: Dumped conversation history to ${fileName} (${globalConversationHistory.length()} messages)`);
//     } on fail error e {
//         log:printError(string `Failed to dump conversation history: ${e.message()}`);
//     }
// }