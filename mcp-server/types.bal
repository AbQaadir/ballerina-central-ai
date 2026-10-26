# Search Ballerina packages in Ballerina Central
# By using this function, you can search for Ballerina packages in Ballerina Central.
# 
# Search by packages
# You can search for packages containing the search text in the package name, organization, keywords, or README file.
# 
# Searching by symbols
# You can search for a symbol by its name across all packages. A symbol can be a record, class, client, function, method, constant, variable, type, or field.
# 
# Search syntax
# - Search by package name
# kafka
# package:kafka
# 
# - Search packages in an organization(s)
# ballerinax/kafka
# org:ballerinax package:kafka
# org:ballerina,ballerinax,wso2 package:kafka
# 
# - Search for all the packages in an organization(s)
# org:ballerina
# org:ballerinax
# org:wso2
# org:ballerina,ballerinax,wso2
# 
# - Search by a keyword
# keyword:time
# keyword:"Cost/Free"
# keyword:"Communication/Team Chat"
# 
# - Exclude terms
# sms -twilio
# google -drive
# 
# - Search with boolean operators
# security AND encryption
# sms AND keyword:"Freemium"
# 
#
# + searchQuery - The search query string.
public type SearchPackagesRequest record {|
    string searchQuery;
|};

# Request type for getting package information
# + orgName - package organization name
# + moduleName - package module name
# + version - package version
public type PackageInfoRequest record {|
    string orgName;
    string moduleName;
    string version;
|};

# Getting all functions information from Ballerina Central's GraphQL API
# By using this function, you can retrieve detailed information about all functions in a specific module
# orgName, moduleName, and version are required to identify the module.
#
# + orgName - The organization name of the module (e.g., "ballerina", "ballerinax")
# + moduleName - The name of the module (e.g., "http", "openai.chat")
# + version - The version of the module (e.g., "2.14.6", "4.0.0")
public type AllFunctionsRequest record {|
    string orgName;
    string moduleName;
    string version;
|};


# Getting all classes information from Ballerina Central's GraphQL API
# By using this function, you can retrieve detailed information about all classes in a specific module
# orgName, moduleName, and version are required to identify the module.
#
# + orgName - The organization name of the module (e.g., "ballerina", "ballerinax")
# + moduleName - The name of the module (e.g., "mime", "http")
# + version - The version of the module (e.g., "2.12.0", "2.14.6")
public type AllClassesRequest record {|
    string orgName;
    string moduleName;
    string version;
|};

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
public type ComprehensiveClassInfoRequest record {|
    string orgName;
    string moduleName;
    string version;
    string className;
|};
