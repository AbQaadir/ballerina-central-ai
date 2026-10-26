// Simplified function information type
public type FunctionInfo record {
    string org;
    string module;
    string version;
    string name;
    string description;
};

// Package information type
public type PackageInfo record {
    string orgName;
    string moduleName;
    string version;
    string description;  // Markdown description of the package
};

// All functions information type
public type AllFunctionsInfo record {
    string orgName;
    string moduleName;
    string version;
    FunctionInfo[] functions;  // Array of all functions in the module
};

// Class information type
public type ClassInfo record {
    string org;
    string module;
    string version;
    string name;
    string description;
};

// All classes information type
public type AllClassesInfo record {
    string orgName;
    string moduleName;
    string version;
    ClassInfo[] classes;  // Array of all classes in the module
};

// Field information for classes
public type FieldInfo record {
    string name;
    string 'type;
    string description;
    string defaultValue?;
};

// Method information for classes (only name and description)
public type MethodInfo record {
    string name;
    string description;
};

// Comprehensive class information type
public type ComprehensiveClassInfo record {
    string org;
    string module;
    string version;
    string name;
    string description;
    FieldInfo[] fields;        // Array of field information
    MethodInfo[] methods;      // Array of method information
    MethodInfo[] otherMethods; // Array of other method information
};