import ballerina/http;
import balMCPServer.httpTools;
import balMCPServer.graphqlTools;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowCredentials: true,
        allowHeaders: ["*"],
        allowMethods: ["*"]
    }
}


service http:Service /api/tools on new http:Listener(9090) {

    resource function post searchBallerinaPackages(@http:Payload SearchPackagesRequest request) returns http:Ok|http:BadRequest|http:InternalServerError {
        
        httpTools:PackageCard[]|error result = httpTools:searchBallerinaPackages(request.searchQuery);
        
        if result is error {
            return <http:InternalServerError>{body: string `Error searching packages: ${result.message()}`};
        }
        
        return <http:Ok>{body: result};
    }

    resource function post getBallerinaPackageDetails(@http:Payload PackageInfoRequest request) returns http:Ok|http:BadRequest|http:InternalServerError {
        graphqlTools:PackageInfo|error result = graphqlTools:getPackageInfo(request.orgName, request.moduleName, request.version);
        
        if result is error {
            return <http:InternalServerError>{body: string `Error getting package info: ${result.message()}`};
        }
        
        return <http:Ok>{body: result};
    }


    resource function post getAllModuleFunctions(@http:Payload AllFunctionsRequest request) returns http:Ok|http:BadRequest|http:InternalServerError {
        graphqlTools:AllFunctionsInfo|error result = graphqlTools:getAllFunctions(request.orgName, request.moduleName, request.version);
        
        if result is error {
            return <http:InternalServerError>{body: string `Error getting functions: ${result.message()}`};
        }
        
        return <http:Ok>{body: result};
    }

    
    resource function post getAllModuleClasses(@http:Payload AllClassesRequest request) returns http:Ok|http:BadRequest|http:InternalServerError {
        graphqlTools:AllClassesInfo|error result = graphqlTools:getAllClasses(request.orgName, request.moduleName, request.version);
        
        if result is error {
            return <http:InternalServerError>{body: string `Error getting classes: ${result.message()}`};
        }
        
        return <http:Ok>{body: result};
    }

    
    resource function post getDetailedClassInformation(@http:Payload ComprehensiveClassInfoRequest request) returns http:Ok|http:BadRequest|http:InternalServerError {
        graphqlTools:ComprehensiveClassInfo|error result = graphqlTools:getComprehensiveClassInfo(request.orgName, request.moduleName, request.version, request.className);
        
        if result is error {
            return <http:InternalServerError>{body: string `Error getting class info: ${result.message()}`};
        }
        
        return <http:Ok>{body: result};
    }
}
