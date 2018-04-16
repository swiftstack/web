import HTTP

public protocol Controller {
    static var basePath: String { get }
    static var middleware: [Middleware.Type] { get }
    static var authorization: Authorization { get }
    static func setup(router: Router<Self>) throws
}

public extension Controller {
    static var basePath: String {
        return ""
    }

    static var middleware: [Middleware.Type] {
        return []
    }

    static var authorization: Authorization {
        return .any
    }
}
