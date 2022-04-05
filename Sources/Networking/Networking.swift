

public struct Networking {

    internal static var shared = Networking()

    internal var feedbackPaths: [String]!
    internal static var feedbackPaths: [String] {
        shared.feedbackPaths
    }
    
    internal var appName: String!
    internal static var appName: String {
        shared.appName
    }
    
    internal var version: Int!
    internal static var version: Int {
        shared.version
    }

    public static func configure(feedbackPaths: [String], appName: String, version: Int) {
        shared.feedbackPaths = feedbackPaths
        shared.appName = appName
        shared.version = version
    }

}
