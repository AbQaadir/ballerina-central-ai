// Types for Ballerina Central package search response

public type Package record {
    int id;
    string organization;
    string name;
    string version;
    string platform;
    string languageSpecificationVersion;
    boolean isDeprecated;
    string deprecateMessage;
    string URL;
    string balaVersion;
    string balaURL;
    string digest;
    string summary;
    string readme;
    boolean template;
    string[] licenses;
    string[] authors;
    string sourceCodeLocation;
    string[] keywords;
    string ballerinaVersion;
    string icon;
    string ownerUUID;
    int createdDate;
    int pullCount;
    string visibility;
    string[] modules;
    string balToolId;
    string graalvmCompatible;
};

public type Highlighting record {
    string[] summary?;
    string[] keywords?;
};

public type PackageSearchData record {
    Package[] packages;
    string[] suggestions;
    map<Highlighting> highlighting;
    int count;
    int offset;
    int 'limit;
};

public type ContentItem record {
    string 'type;
    string text;
};

public type PackageSearchResponse record {
    ContentItem[] content;
};


public type PackageCard record {
    string organization;
    string name;
    string version;
    string URL;
    string[] keywords;
    string icon;
    string summary;
};