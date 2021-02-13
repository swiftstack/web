public struct AuthorizationMiddleware: Middleware {
    public static func chain(
        with middleware: @escaping (Context) async throws -> Void
    ) -> (Context) async throws -> Void {
        return { context in
            let auth = try context.services.resolve(AuthorizationProtocol.self)
            try auth.authenticate(context: context)
            let result = context.authorization.challenge(user: context.user)
            switch result {
            case .ok: try await middleware(context)
            case .unauthorized: auth.accessDenied(context: context)
            case .unauthenticated: auth.loginRequired(context: context)
            }
        }
    }
}
