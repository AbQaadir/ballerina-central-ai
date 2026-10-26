import ballerina/mcp;
import balMCPClient.gemini;

# Process Gemini response and handle function calls
# This function checks if the model wants to make a tool call, executes it if needed,
# and returns the appropriate response content
#
# + modelResponse - The response from Gemini
# + mcpClient - The MCP client for tool calls
# + return - Processed response with content to add to conversation
public function processGeminiResponse(gemini:GenerateContentResponse modelResponse, mcp:StreamableHttpClient mcpClient) returns ProcessedResponse|error {
    
    gemini:Content modelContent = modelResponse.candidates[0].content;
    boolean hasFunctionCall = false;
    string functionName = "";
    map<anydata> functionArgs = {};

    // Check if the model wants to call a function
    foreach gemini:Part part in modelContent.parts {
        gemini:FunctionCall? functionCall = part.functionCall;
        if functionCall is gemini:FunctionCall {
            hasFunctionCall = true;
            functionName = functionCall.name;
            functionArgs = functionCall.args ?: {};
            break;
        }
    }

    if hasFunctionCall {

        mcp:CallToolParams toolParams = {
            name: functionName,
            arguments: functionArgs
        };
        
        mcp:CallToolResult callToolResult = check mcpClient->callTool(toolParams);

        gemini:FunctionResponse functionResponse = check mcpToGeminiFunctionResponse(callToolResult, functionName);

        gemini:Content functionResponseContent = {
            parts: [
                {
                    functionResponse: functionResponse
                }
            ],
            role: "user"
        };
        
        return {
            hasFunctionCall: true,
            responseContent: functionResponseContent,
            functionName: functionName,
            functionArgs: functionArgs
        };
    } else {
        
        return {
            hasFunctionCall: false,
            responseContent: modelContent,
            functionName: (),
            functionArgs: ()
        };
    }
}

# Execute a complete conversation turn that may include function calls
# This function handles the full cycle: check for function call -> execute -> get final response
#
# + modelResponse - The initial response from Gemini
# + mcpClient - The MCP client for tool calls
# + geminiClient - The Gemini client for follow-up requests
# + conversationContents - The current conversation history
# + geminiTools - The tools available to Gemini
# + model - The Gemini model name
# + return - Updated conversation contents and final response
public function executeConversationTurn(
    gemini:GenerateContentResponse modelResponse,
    mcp:StreamableHttpClient mcpClient,
    gemini:Client geminiClient,
    gemini:Content[] conversationContents,
    gemini:Tool geminiTools,
    string model
) returns record {| gemini:Content[] contents; gemini:Content finalResponse; |}|error {
    
    // Make a copy of conversation contents to avoid modifying the original
    gemini:Content[] updatedContents = conversationContents.clone();
    
    // First, add the model's initial response
    updatedContents.push(modelResponse.candidates[0].content);
    
    // Process the response (check for function calls and execute if needed)
    ProcessedResponse processed = check processGeminiResponse(modelResponse, mcpClient);
    
    if processed.hasFunctionCall {
        // Add the function response to conversation
        updatedContents.push(processed.responseContent);
        
        // Create system instruction from prompt
        gemini:Content systemInstruction = {
            parts: [
                {
                    text: systemPrompt
                }
            ]
        };

        // Make follow-up request to get final response
        gemini:GenerateContentRequest followUpRequest = {
            model: model,
            systemInstruction: systemInstruction,
            contents: updatedContents,
            tools: [geminiTools]
        };

        // Make the follow-up API call
        gemini:GenerateContentResponse finalResponse = check geminiClient->generativeServiceGenerateModelContent(
            model, followUpRequest
        );

        // Add final response to conversation
        updatedContents.push(finalResponse.candidates[0].content);
        
        return {
            contents: updatedContents,
            finalResponse: finalResponse.candidates[0].content
        };
    } else {
        // No function call, just return the model response
        return {
            contents: updatedContents,
            finalResponse: processed.responseContent
        };
    }
}