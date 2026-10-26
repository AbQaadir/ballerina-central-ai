import ballerina/http;

# Getting package information from Ballerina Central's GraphQL API
# By using this function, you can retrieve detailed information about a specific package/module
# including its markdown description and overview documentation.
#
# + orgName - The organization name of the module (e.g., "ballerina", "ballerinax")
# + moduleName - The name of the module (e.g., "http", "openai.chat")
# + version - The version of the module (e.g., "2.14.6", "4.0.0")
# + return - A record containing the package's organization, module name, version, and description
public isolated function getPackageInfo(string orgName, string moduleName, string version) returns PackageInfo|error {
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
                        description
                    }
                }
            }
        }`
    };
    
    json response = check graphqlClient->post("/", query);
    
    // Navigate to the package data
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
    json description = check firstModule.description;
    
    // Return simplified PackageInfo
    return {
        orgName: orgName,
        moduleName: moduleName,
        version: version,
        description: description.toString()
    };
}