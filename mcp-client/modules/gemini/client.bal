import ballerina/data.jsondata;
import ballerina/http;

# API for using Large Models that generate multimodal content and have
#  additional capabilities beyond text generation.
public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + apiKeyConfig - API keys for authorization 
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ApiKeysConfig apiKeyConfig, ConnectionConfig config =  {}, string serviceUrl = "https://generativelanguage.googleapis.com") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, http1Settings: config.http1Settings, http2Settings: config.http2Settings, timeout: config.timeout, forwarded: config.forwarded, followRedirects: config.followRedirects, poolConfig: config.poolConfig, cache: config.cache, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, cookieConfig: config.cookieConfig, responseLimits: config.responseLimits, secureSocket: config.secureSocket, proxy: config.proxy, socketConfig: config.socketConfig, validation: config.validation, laxDataBinding: config.laxDataBinding};
        self.clientEp = check new (serviceUrl, httpClientConfig);
        self.apiKeyConfig = apiKeyConfig.cloneReadOnly();
    }

    # Generates a model response for a dynamic model.
    #
    # + dynamic - The dynamic id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceGenerateDynamicContent(string dynamic, GenerateContentRequest payload, map<string|string[]> headers = {}) returns GenerateContentResponse|error {
        string resourcePath = string `/v1beta/dynamic/${getEncodedUri(dynamic)}:generateContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a streamed response from a dynamic model.
    #
    # + dynamic - The dynamic id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceStreamGenerateDynamicContent(string dynamic, GenerateContentRequest payload, map<string|string[]> headers = {}) returns GenerateContentResponse|error {
        string resourcePath = string `/v1beta/dynamic/${getEncodedUri(dynamic)}:streamGenerateContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates multiple embedding vectors from the input `Content` which
    #  consists of a batch of strings represented as `EmbedContentRequest`
    #  objects.
    #
    # + model - The model id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceBatchEmbedContents(string model, BatchEmbedContentsRequest payload, map<string|string[]> headers = {}) returns BatchEmbedContentsResponse|error {
        string resourcePath = string `/v1beta/models/${getEncodedUri(model)}:batchEmbedContents`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Runs a model's tokenizer on input `Content` and returns the token count.
    #  Refer to the [tokens guide](https://ai.google.dev/gemini-api/docs/tokens)
    #  to learn more about tokens.
    #
    # + model - The model id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceCountTokens(string model, CountTokensRequest payload, map<string|string[]> headers = {}) returns CountTokensResponse|error {
        string resourcePath = string `/v1beta/models/${getEncodedUri(model)}:countTokens`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a text embedding vector from the input `Content` using the
    #  specified [Gemini Embedding
    #  model](https://ai.google.dev/gemini-api/docs/models/gemini#text-embedding).
    #
    # + model - The model id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceEmbedContent(string model, EmbedContentRequest payload, map<string|string[]> headers = {}) returns EmbedContentResponse|error {
        string resourcePath = string `/v1beta/models/${getEncodedUri(model)}:embedContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a grounded answer from the model given an input
    #  `GenerateAnswerRequest`.
    #
    # + model - The model id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceGenerateAnswer(string model, GenerateAnswerRequest payload, map<string|string[]> headers = {}) returns GenerateAnswerResponse|error {
        string resourcePath = string `/v1beta/models/${getEncodedUri(model)}:generateAnswer`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a model response for a standard model.
    #
    # + model - The model id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceGenerateModelContent(string model, GenerateContentRequest payload, map<string|string[]> headers = {}) returns GenerateContentResponse|error {
        string resourcePath = string `/v1beta/models/${getEncodedUri(model)}:generateContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a streamed response from a standard model.
    #
    # + model - The model id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceStreamGenerateModelContent(string model, GenerateContentRequest payload, map<string|string[]> headers = {}) returns GenerateContentResponse|error {
        string resourcePath = string `/v1beta/models/${getEncodedUri(model)}:streamGenerateContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a model response for a tuned model.
    #
    # + tunedModel - The tunedModel id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceGenerateTunedModelContent(string tunedModel, GenerateContentRequest payload, map<string|string[]> headers = {}) returns GenerateContentResponse|error {
        string resourcePath = string `/v1beta/tunedModels/${getEncodedUri(tunedModel)}:generateContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Generates a streamed response from a tuned model.
    #
    # + tunedModel - The tunedModel id.
    # + headers - Headers to be sent with the request 
    # + return - OK 
    remote isolated function generativeServiceStreamGenerateTunedModelContent(string tunedModel, GenerateContentRequest payload, map<string|string[]> headers = {}) returns GenerateContentResponse|error {
        string resourcePath = string `/v1beta/tunedModels/${getEncodedUri(tunedModel)}:streamGenerateContent`;
        map<anydata> headerValues = {...headers};
        headerValues["x-goog-api-key"] = self.apiKeyConfig.xGoogApiKey;
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }
}
