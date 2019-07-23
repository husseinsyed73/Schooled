import Foundation

/// :nodoc:
@available(*, deprecated, message: "all requests should now contain a `parameters` property that is `Encodable`.")
public protocol AutoEncodable: Encodable {
    /// The date and date encoding strategy.
    var encodingStrategy: EncodingStrategy { get }
    
    /// The encoded data representation.
    func encode(formatting: JSONEncoder.OutputFormatting) -> Data?
    
    /// The encoded string representation.
    func encodedString(formatting: JSONEncoder.OutputFormatting) -> String?
}
