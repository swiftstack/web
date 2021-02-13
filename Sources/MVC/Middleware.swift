public protocol Middleware {
    static func chain(
        with middleware: @escaping (Context) async throws -> Void
    ) -> (Context) async throws -> Void
}
