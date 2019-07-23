import Foundation

public extension ModeledRequest {
    /// :nodoc:
    @available(*, deprecated, renamed: "endpointPath")
    var endpoint: URLComponents? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the new methods in `Session` to faciliate building the URL request.")
    func generateUrlRequest() throws -> URLRequest {
        throw Exception.Request.couldNotConstructUrlRequest
    }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    var contentType: ContentType { return .json }
    
    /// :nodoc:
    @available(*, deprecated, message: "use the `headers` property to set any headers on the request.")
    var acceptType: ContentType { return .json }
}
