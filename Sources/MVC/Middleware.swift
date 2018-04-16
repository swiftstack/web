public protocol Middleware {
    static func chain(
        with middleware: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void
}
