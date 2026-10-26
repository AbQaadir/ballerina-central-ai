import ballerina/mcp;
import balMCPClient.gemini;
import ballerina/data.jsondata;
import ballerina/time;

# Convert MCP CallToolResult to Gemini FunctionResponse
# This function works for all MCP tools as it generically extracts and parses JSON content
#
# + mcpResult - The MCP tool call result
# + toolName - The name of the tool that was called
# + return - Gemini FunctionResponse object
public function mcpToGeminiFunctionResponse(mcp:CallToolResult mcpResult, string toolName) returns gemini:FunctionResponse|error {
    
    // Extract the text content from MCP result
    string responseText = "";
    
    // Handle multiple content items if present
    foreach var contentItem in mcpResult.content {
        if contentItem is map<anydata> {
            anydata typeValue = contentItem["type"];
            anydata textValue = contentItem["text"];
            
            if typeValue is string && typeValue == "text" && textValue is string {
                responseText += textValue;
            }
        }
    }
    
    // Check if we got any content
    if responseText.trim() == "" {
        return error("No text content found in MCP result");
    }
    
    // Try to parse as JSON, fallback to plain text if it fails
    anydata parsedData;
    json|error parseResult = jsondata:parseString(responseText);
    if parseResult is error {
        // If JSON parsing fails, treat as plain text response
        parsedData = responseText;
    } else {
        parsedData = parseResult;
    }
    
    // Create the Gemini FunctionResponse
    gemini:FunctionResponse functionResponse = {
        name: toolName,
        response: {
            "data": parsedData,
            "success": true,
            "toolName": toolName,
            "responseType": parsedData is string ? "text" : "json"
        }
    };
    
    return functionResponse;
}

# Convert MCP CallToolResult to Gemini FunctionResponse with specific tool response type
#
# + mcpResult - The MCP tool call result
# + toolName - The name of the tool that was called
# + id - Optional function call ID
# + return - Gemini FunctionResponse object
public function mcpToGeminiFunctionResponseWithId(mcp:CallToolResult mcpResult, string toolName, string? id = ()) returns gemini:FunctionResponse|error {
    
    // Extract the text content from MCP result
    string responseText = "";
    
    foreach var contentItem in mcpResult.content {
        if contentItem is map<anydata> {
            anydata typeValue = contentItem["type"];
            anydata textValue = contentItem["text"];
            
            if typeValue is string && typeValue == "text" && textValue is string {
                responseText += textValue;
            }
        }
    }
    
    // Parse the JSON string to get the actual data
    anydata parsedData = check jsondata:parseString(responseText);
    
    // Create the Gemini FunctionResponse with optional ID
    gemini:FunctionResponse functionResponse = {
        name: toolName,
        response: {
            "data": parsedData,
            "success": true,
            "timestamp": time:utcNow()
        }
    };
    
    // Add ID if provided
    if id is string {
        functionResponse.id = id;
    }
    
    return functionResponse;
}
