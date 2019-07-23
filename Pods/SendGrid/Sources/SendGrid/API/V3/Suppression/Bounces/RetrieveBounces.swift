import Foundation

/// The `RetrieveBounces` class represents the API call to [retrieve the bounce
/// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#List-all-bounces-GET).
/// You can use it to retrieve the entire list, or specific entries in the
/// list.
///
/// ## Get All Bounces
///
/// To retrieve the list of all bounces, use the `RetrieveBounces` class with the
/// `init(start:end:page:)` initializer. The library will automatically map
/// the response to the `Bounce` struct model, accessible via the `model`
/// property on the response instance you get back.
///
/// ```swift
/// do {
///     // If you don't specify any parameters, then the first page of your entire
///     // bounce list will be fetched:
///     let request = RetrieveBounces()
///     try Session.shared.send(modeledRequest: request) { result in
///         switch result {
///         case .success(let response, let model):
///             // The `model` property will be an array of `Bounce` structs.
///             model.forEach { print($0.email) }
///
///             // The response object has a `Pagination` instance on it as well.
///             // You can use this to get the next page, if you wish.
///             if let nextPage = response.pages?.next {
///                 let nextRequest = RetrieveBounces(page: nextPage)
///             }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// You can also specify any or all of the init parameters to filter your
/// search down:
///
/// ```swift
/// do {
///     // Retrieve page 2
///     let page = Page(limit: 500, offset: 500)
///     // Bounces starting from yesterday
///     let now = Date()
///     let start = now.addingTimeInterval(-86400) // 24 hours
///
///     let request = RetrieveBounces(start: start, end: now, page: page)
///     try Session.shared.send(modeledRequest: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` property will be an array of `Bounce` structs.
///             model.forEach { print($0.email) }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// ## Get Specific Bounce
///
/// If you're looking for a specific email address in the bounce list, you
/// can use the `init(email:)` initializer on `RetrieveBounces`:
///
/// ```swift
/// do {
///     let request = RetrieveBounces(email: "foo@example.none")
///     try Session.shared.send(modeledRequest: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` property will be an array of `Bounce` structs.
///             if let match = model.first {
///                 print("\(match.email) bounced with reason \"\(match.reason)\"")
///             }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveBounces: SuppressionListReader<Bounce> {
    /// :nodoc:
    internal override init(path: String?, email: String?, start: Date?, end: Date?, page: Page?) {
        super.init(
            path: "/v3/suppression/bounces",
            email: email,
            start: start,
            end: end,
            page: page
        )
    }
}
