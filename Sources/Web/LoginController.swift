import enum HTTP.Error
import struct HTTP.Cookie

public final class LoginController: Controller, Inject2Services {
    public static func setup(router: Router<LoginController>) throws {
        router.route(post: "/register", authorizing: .guest, to: register)
        router.route(post: "/login", authorizing: .guest, to: login)
        router.route(post: "/logout", authorizing: .user, to: logout)
    }

    let context: Context
    let users: UserManager

    public init(_ context: Context, _ users: UserManager) {
        self.context = context
        self.users = users
    }

    func register(credentials: User.NewCredentials) throws -> User {
        let user = try users.register(credentials)
        guard let id = user.id else {
            throw HTTP.Server.Error.internalServerError
        }
        context.signIn(id: id)
        return user
    }

    func login(credentials: User.Credentials) throws -> String {
        let user = try users.login(credentials)
        guard let id = user.id else {
            throw HTTP.Server.Error.internalServerError
        }
        context.signIn(id: id)
        return user.name
    }

    func logout() throws {
        context.signOut()
    }
}

extension Context {
    func signIn(id: String) {
        let name = CookieAuthorization.userCookieName
        let cookie = SetCookie(name: name, value: id, httpOnly: true)
        cookies[setCookie: name] = cookie
    }

    func signOut() {
        cookies[CookieAuthorization.userCookieName] = nil
    }
}
