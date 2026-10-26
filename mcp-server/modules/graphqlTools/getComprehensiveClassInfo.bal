import ballerina/http;

# Getting comprehensive class information from Ballerina Central's GraphQL API
# By using this function, you can retrieve information about a specific class
# including all fields with types and descriptions, and all methods with 
# names and descriptions.
# orgName, moduleName, version, and className are required to identify the class.
#
# + orgName - The organization name of the module (e.g., "ballerina", "ballerinax")
# + moduleName - The name of the module (e.g., "mime", "http")
# + version - The version of the module (e.g., "2.12.0", "2.14.6")
# + className - The name of the class (e.g., "ContentDisposition", "Entity")
# + return - A record containing class information including fields and methods with names and descriptions
public isolated function getComprehensiveClassInfo(string orgName, string moduleName, string version, string className) returns ComprehensiveClassInfo|error {
    http:Client graphqlClient = check new ("https://api.central.ballerina.io/2.0/graphql");
    
    json query = {
        "query": string `query Package {
            apiDocs(
                inputFilter: {
                    moduleInfo: { orgName: "${orgName}", moduleName: "${moduleName}", version: "${version}" }
                    classFilter: { name: "${className}" }
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
    
    // Parse the JSON string to get the actual class data
    json classJson = check classesJsonString.toString().fromJsonString();
    
    // Extract basic class information
    json name = check classJson.name;
    json description = check classJson.description;
    
    // Extract fields with complete information
    FieldInfo[] fields = [];
    json fieldsArray = check classJson.fields;
    if fieldsArray is json[] {
        foreach json fieldJson in fieldsArray {
            json fieldName = check fieldJson.name;
            json fieldDescription = check fieldJson.description;
            json fieldType = check fieldJson.'type;
            json fieldTypeName = check fieldType.name;
            
            FieldInfo fieldInfo = {
                name: fieldName.toString(),
                'type: fieldTypeName.toString(),
                description: fieldDescription.toString()
            };
            
            // Add default value if present
            json|error fieldDefaultValue = fieldJson.defaultValue;
            if fieldDefaultValue is json && fieldDefaultValue.toString() != "" {
                fieldInfo.defaultValue = fieldDefaultValue.toString();
            }
            
            fields.push(fieldInfo);
        }
    }
    
    // Extract methods with complete information
    MethodInfo[] methods = [];
    json methodsArray = check classJson.methods;
    if methodsArray is json[] {
        foreach json methodJson in methodsArray {
            MethodInfo methodInfo = extractMethodInfo(methodJson);
            methods.push(methodInfo);
        }
    }
    
    // Extract other methods with complete information
    MethodInfo[] otherMethods = [];
    json|error otherMethodsArray = classJson.otherMethods;
    if otherMethodsArray is json[] {
        foreach json methodJson in otherMethodsArray {
            MethodInfo methodInfo = extractMethodInfo(methodJson);
            otherMethods.push(methodInfo);
        }
    }
    
    // Return ComprehensiveClassInfo
    return {
        org: orgName,
        module: moduleName,
        version: version,
        name: name.toString(),
        description: description.toString(),
        fields: fields,
        methods: methods,
        otherMethods: otherMethods
    };
}

# Helper function to extract method information from JSON
# + methodJson - JSON object containing method information
# + return - MethodInfo record with method name and description
isolated function extractMethodInfo(json methodJson) returns MethodInfo {
    json|error methodName = methodJson.name;
    json|error methodDescription = methodJson.description;
    
    return {
        name: methodName is json ? methodName.toString() : "",
        description: methodDescription is json ? methodDescription.toString() : ""
    };
}