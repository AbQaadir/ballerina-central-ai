import ballerina/http;

// HTTP client for Ballerina Central API
final http:Client ballerinaClient = check new ("https://api.central.ballerina.io");

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
# + offset - The offset for pagination. Always defaults to 0.
# + limit - The maximum number of results to return. Always defaults to 5.
# + readme - Whether to include README content in the search. Always defaults to false.
# + sort - The sorting criteria for the results. Always defaults to "relevance,DESC".
# + return - A JSON object containing the search results or an error. 
public isolated function searchBallerinaPackages(string searchQuery, 
                                       int offset = 0, 
                                       int 'limit = 5, 
                                       boolean readme = false, 
                                       string sort = "relevance,DESC") returns PackageCard[]|error {
    
    // Build API endpoint
    string url = string `/2.0/registry/search-packages?q=${searchQuery}&offset=${offset}&limit=${'limit}&readme=${readme}&sort=${sort}`;
    
    // Make request and return JSON
    PackageSearchData|error response = ballerinaClient->get(url);
    
    if response is error {
        return response;
    }

    PackageCard[] packageCards = [];
    
    foreach var pkg in response.packages {
        packageCards.push({
            name: pkg.name,
            organization: pkg.organization,
            version: pkg.version,
            summary: pkg.summary,
            URL: pkg.URL,
            keywords: pkg.keywords,
            icon: pkg.icon
        });
    }

    return packageCards;
}