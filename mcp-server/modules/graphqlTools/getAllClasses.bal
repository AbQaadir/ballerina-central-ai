import ballerina/http;

# Getting all classes information from Ballerina Central's GraphQL API
# By using this function, you can retrieve detailed information about all classes in a specific module
# orgName, moduleName, and version are required to identify the module.
#
# + orgName - The organization name of the module (e.g., "ballerina", "ballerinax")
# + moduleName - The name of the module (e.g., "mime", "http")
# + version - The version of the module (e.g., "2.12.0", "2.14.6")
# + return - A record containing the module info and array of all classes with their names and descriptions
public isolated function getAllClasses(string orgName, string moduleName, string version) returns AllClassesInfo|error {
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
                        classes
                    }
                }
            }
        }`
    };
    
    json response = check graphqlClient->post("/", query);
    
    // Navigate to the classes data
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
    json classesJsonString = check firstModule.classes;
    
    // Parse the JSON string to get the actual classes array
    json classesJson = check classesJsonString.toString().fromJsonString();
    
    // Handle both single class object and array of classes
    json[] classesArray;
    if classesJson is json[] {
        classesArray = classesJson;
    } else {
        // If it's a single class object, wrap it in an array
        classesArray = [classesJson];
    }
    
    // Extract class information from each class
    ClassInfo[] classes = [];
    
    foreach json classJson in classesArray {
        json name = check classJson.name;
        json description = check classJson.description;
        
        ClassInfo classInfo = {
            org: orgName,
            module: moduleName,
            version: version,
            name: name.toString(),
            description: description.toString()
        };
        
        classes.push(classInfo);
    }
    
    // Return AllClassesInfo
    return {
        orgName: orgName,
        moduleName: moduleName,
        version: version,
        classes: classes
    };
}
