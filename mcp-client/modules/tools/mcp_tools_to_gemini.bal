import ballerina/mcp;
import balMCPClient.gemini;

# Converts MCP tools to Gemini tools format
# 
# + mcpTools - Array of MCP tool definitions
# + return - Gemini Tool with function declarations
public function convertMcpToolsToGeminiTool(mcp:ToolDefinition[] mcpTools) returns gemini:Tool {
    gemini:FunctionDeclaration[] functionDeclarations = [];
    
    foreach mcp:ToolDefinition mcpTool in mcpTools {
        gemini:FunctionDeclaration geminiFunction = convertMcpToolToGeminiFunctionDeclaration(mcpTool);
        functionDeclarations.push(geminiFunction);
    }
    
    return {
        functionDeclarations: functionDeclarations
    };
}

# Converts a single MCP tool to Gemini function declaration
# 
# + mcpTool - MCP tool definition
# + return - Gemini function declaration
public function convertMcpToolToGeminiFunctionDeclaration(mcp:ToolDefinition mcpTool) returns gemini:FunctionDeclaration {
    // Convert inputSchema to parameters
    gemini:Schema? parameters = ();
    
    if mcpTool.inputSchema is record {} {
        parameters = convertJsonSchemaToGeminiSchema(mcpTool.inputSchema);
    }
    
    return {
        name: mcpTool.name,
        description: mcpTool.description ?: "",
        parameters: parameters
    };
}

# Converts JSON schema format to Gemini Schema format
# 
# + jsonSchema - JSON schema record
# + return - Gemini Schema
function convertJsonSchemaToGeminiSchema(record {} jsonSchema) returns gemini:Schema {
    // Default type to "object" if not specified
    string schemaType = "object";
    
    // Handle type
    if jsonSchema.hasKey("type") {
        anydata typeValue = jsonSchema.get("type");
        if typeValue is string {
            schemaType = typeValue;
        }
    }

    gemini:Schema geminiSchema = {
        'type: schemaType
    };
    
    // Handle description
    if jsonSchema.hasKey("description") {
        anydata descValue = jsonSchema.get("description");
        if descValue is string {
            geminiSchema.description = descValue;
        }
    }
    
    // Handle properties
    if jsonSchema.hasKey("properties") {
        anydata propsValue = jsonSchema.get("properties");
        if propsValue is record {} {
            record {| gemini:Schema...;|} properties = {};
            foreach string key in propsValue.keys() {
                anydata propValue = propsValue.get(key);
                if propValue is record {} {
                    properties[key] = convertJsonSchemaToGeminiSchema(propValue);
                }
            }
            geminiSchema.properties = properties;
        }
    }
    
    // Handle required
    if jsonSchema.hasKey("required") {
        anydata reqValue = jsonSchema.get("required");
        if reqValue is anydata[] {
            string[] required = [];
            foreach anydata item in reqValue {
                if item is string {
                    required.push(item);
                }
            }
            geminiSchema.required = required;
        }
    }
    
    // Handle enum
    if jsonSchema.hasKey("enum") {
        anydata enumValue = jsonSchema.get("enum");
        if enumValue is anydata[] {
            string[] enumArray = [];
            foreach anydata item in enumValue {
                if item is string {
                    enumArray.push(item);
                }
            }
            geminiSchema.'enum = enumArray;
        }
    }
    
    // Handle items (for arrays)
    if jsonSchema.hasKey("items") {
        anydata itemsValue = jsonSchema.get("items");
        if itemsValue is record {} {
            geminiSchema.items = convertJsonSchemaToGeminiSchema(itemsValue);
        }
    }
    
    return geminiSchema;
}