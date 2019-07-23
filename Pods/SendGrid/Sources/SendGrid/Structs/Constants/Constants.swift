import Foundation

/// The `Constants` struct houses all the constant values used throughout the
/// library.
public struct Constants {
    // MARK: - Global Constants
    
    /// The host to use for the API calls.
    public static var ApiHost: String = "https://api.sendgrid.com/"
    
    /// The version number of the library.
    public static let Version: String = "2.0.0"
    
    /// The upper limit to the number of personalizations allowed in an email.
    public static let PersonalizationLimit: Int = 1000
    
    /// The upper limit to the number of recipients that can be in an email.
    public static let RecipientLimit: Int = 1000
    
    /// The upper limit on how many substitutions are allowed.
    public static let SubstitutionLimit: Int = 10000
    
    /// The maximum amount of seconds in the future an email can be scheduled
    /// for.
    public static let ScheduleLimit: TimeInterval = (72 * 60 * 60)
    
    /// Constants for categories
    public struct Categories {
        /// The max number of categories allowed in an email.
        public static let TotalLimit: Int = 10
        
        /// The max number of characters allowed in a category name.
        public static let CharacterLimit: Int = 255
    }
    
    /// Constants for the subscription tracking setting.
    public struct SubscriptionTracking {
        /// The default verbiage for the plain text unsubscribe footer.
        public static let DefaultPlainText = "If you would like to unsubscribe and stop receiving these emails click here: <% %>."
        
        /// The default verbiage for the HTML text unsubscribe footer.
        public static let DefaultHTMLText = "<p>If you would like to unsubscribe and stop receiving these emails <% click here %>.</p>"
    }
    
    /// Constants for custom arguments.
    public struct CustomArguments {
        /// The maximum number of bytes allowed for custom arguments in an email.
        public static let MaximumBytes: Int = 10000
    }
    
    /// Constants for ASM.
    public struct UnsubscribeGroups {
        /// The maximum number of unsubscribe groups you can specify in the
        /// `groupsToDisplay` property.
        public static let MaximumNumberOfDisplayGroups: Int = 25
    }
}
