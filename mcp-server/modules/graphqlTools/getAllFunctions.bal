import ballerina/http;

# Getting all functions information from Ballerina Central's GraphQL API
# By using this function, you can retrieve detailed information about all functions in a specific module
# orgName, moduleName, and version are required to identify the module.
#
# + orgName - The organization name of the module (e.g., "ballerina", "ballerinax")
# + moduleName - The name of the module (e.g., "http", "openai.chat")
# + version - The version of the module (e.g., "2.14.6", "4.0.0")
# + return - A record containing the module info and array of all functions with their names and descriptions
public isolated function getAllFunctions(string orgName, string moduleName, string version) returns AllFunctionsInfo|error {
    http:Client graphqlClient = check new ("https://api.central.ballerina.io/2.0/graphql");
    
    json query = {
        "query": string `query Package {
            apiDocs(
                inputFilter: {
                    moduleInfo: { orgName: "${orgName}", moduleName: "${moduleName}", version: "${version}" }
                }
            ) {
                docsData {
                    modules {
                        functions
                    }
                }
            }
        }`
    };
    
    json response = check graphqlClient->post("/", query);
    
    // Navigate to the functions data
    json dataField = check response.data;
    json apiDocs = check dataField.apiDocs;
    json docsData = check apiDocs.docsData;
    json modules = check docsData.modules;
    
    // Get the first module (it's an array)
    json[] moduleArray = check modules.cloneWithType();
    
    if moduleArray.length() == 0 {
        return error("No modules found in the response");
    }
    
    json firstModule = moduleArray[0];
    json functionsJsonString = check firstModule.functions;
    
    // Parse the JSON string to get the actual functions array
    json functionsJson = check functionsJsonString.toString().fromJsonString();
    
    // Handle both single function object and array of functions
    json[] functionsArray;
    if functionsJson is json[] {
        functionsArray = functionsJson;
    } else {
        // If it's a single function object, wrap it in an array
        functionsArray = [functionsJson];
    }
    
    // Extract function information from each function
    FunctionInfo[] functions = [];
    
    foreach json functionJson in functionsArray {
        json name = check functionJson.name;
        json description = check functionJson.description;
        
        FunctionInfo functionInfo = {
            org: orgName,
            module: moduleName,
            version: version,
            name: name.toString(),
            description: description.toString()
        };
        
        functions.push(functionInfo);
    }
    
    // Return AllFunctionsInfo
    return {
        orgName: orgName,
        moduleName: moduleName,
        version: version,
        functions: functions
    };
}
