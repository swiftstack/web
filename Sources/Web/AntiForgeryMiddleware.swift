import class HTTP.Request
import class HTTP.Response
import struct HTTP.HeaderName
import struct Foundation.UUID

public struct AntiForgeryMiddleware: Middleware {
    static var tokenCookieName = "X-CSRF-Token"
    static var tokenHeaderName: HeaderName = "X-CSRF-Token"

    public static func chain(
        with middleware: @escaping (Context) async throws -> Void
    ) -> (Context) async throws -> Void {
        return { context in
            guard !context.request.isSafe else {
                // generate new token if empty
                if context.cookies[tokenCookieName] == nil {
                    context.cookies[tokenCookieName] = UUID().uuidString
                }
                try await middleware(context)
                return
            }

            // validate token for unsafe requests (post, etc.)
            guard let token = context.cookies[tokenCookieName],
                context.request.headers[tokenHeaderName] == token else {
                    context.response = Response(status: .badRequest)
                    return
            }
            try await middleware(context)
        }
    }
}

extension Request {
    var isSafe: Bool {
        switch method {
        case .get, .head, .options: return true
        default: return false
        }
    }
}
