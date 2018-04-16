public protocol AuthorizationProtocol {
    func authenticate(context: Context) throws
    func loginRequired(context: Context)
    func accessDenied(context: Context)
}
