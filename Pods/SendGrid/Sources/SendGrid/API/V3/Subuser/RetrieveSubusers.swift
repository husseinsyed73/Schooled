import Foundation

/// This class is used to make the
/// [get subusers](https://sendgrid.com/docs/API_Reference/Web_API_v3/subusers.html#List-all-Subusers-for-a-parent-GET)
/// API call.
///
/// You can provide pagination information, and also search by username.  If
/// you partial searches are allowed, so for instance if you had a subuser
/// with username `foobar`, searching for `foo` would return it.
///
/// ```swift
/// do {
///     let search = RetrieveSubusers(username: "foo")
///     try Session.shared.send(modeledRequest: search) { result in
///         switch result {
///         case .success(_, let list):
///             // The `list` variable will be an array of
///             // `Subuser` instances.
///             list.forEach { print($0.username) }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveSubusers: ModeledRequest<[Subuser], RetrieveSubusers.Parameters> {
    // MARK: - Initialization
    
    /// Initializes the request with pagination info and a username search.
    /// If you don't specify a `username` value, then all subusers will be
    /// returned.
    ///
    /// - Parameters:
    ///   - page:       Provides `limit` and `offset` information to
    ///                 paginate the results.
    ///   - username:   A basic search applied against the subusers'
    ///                 usernames. You can provide a partial username. For
    ///                 instance, if you have a subuser with the username
    ///                 `foobar`, searching for `foo` will return it.
    public init(page: Page? = nil, username: String? = nil) {
        super.init(
            method: .GET,
            path: "/v3/subusers",
            parameters: Parameters(page: page, username: username)
        )
    }
    
    // MARK: - Methods
    
    /// Validates that the `limit` value isn't over 500.
    public override func validate() throws {
        try super.validate()
        if let limit = self.parameters?.page?.limit {
            let range = 1...500
            guard range ~= limit else { throw Exception.Global.limitOutOfRange(limit, range) }
        }
    }
}

public extension RetrieveSubusers /* Parameters Struct */ {
    /// The `RetrieveSubusers.Parameters` struct holds all the parameters that
    /// can be used in the `RetrieveSubusers` call.
    struct Parameters: Codable {
        // MARK: - Properties
        
        /// The page range to retrieve.
        public var page: Page?
        
        /// A specific username to search for.
        public var username: String?
        
        // MARK: - Initialization
        
        /// Initializes the struct.
        ///
        /// - Parameters:
        ///   - page:       The page range to retrieve.
        ///   - username:   A specific username to search for.
        public init(page: Page? = nil, username: String? = nil) {
            self.page = page
            self.username = username
        }
        
        /// :nodoc:
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: RetrieveSubusers.Parameters.CodingKeys.self)
            if let limit = try container.decodeIfPresent(Int.self, forKey: .limit),
                let offset = try container.decodeIfPresent(Int.self, forKey: .offset) {
                self.page = Page(limit: limit, offset: offset)
            }
            self.username = try container.decodeIfPresent(String.self, forKey: .username)
        }
        
        /// :nodoc:
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: RetrieveSubusers.Parameters.CodingKeys.self)
            try container.encodeIfPresent(self.page?.limit, forKey: .limit)
            try container.encodeIfPresent(self.page?.offset, forKey: .offset)
            try container.encodeIfPresent(self.username, forKey: .username)
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case limit
            case offset
            case username
        }
    }
}
