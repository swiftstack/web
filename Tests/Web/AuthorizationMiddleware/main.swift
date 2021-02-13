import Test
@testable import MVC
@testable import Web

struct TestAuthorization: AuthorizationProtocol, Inject {
    func authenticate(context: Context) throws {
        switch context.request.url.query {
        case .some(let query) where query["token"] == "a":
            context.user = User(
                name: "admin",
                email: "",
                password: "",
                claims: ["admin"])
        case .some(let query) where query["token"] == "u":
            context.user = User(
                name: "user",
                email: "",
                password: "",
                claims: ["user"])
        default:
            context.user = nil
        }
    }

    func loginRequired(context: Context) {
        context.response = Response(status: .unauthorized)
        context.response.string = "login required"
    }

    func accessDenied(context: Context) {
        context.response = Response(status: .unauthorized)
        context.response.string = "access denied"
    }
}

final class TestController: Controller, InjectService {
    static var middleware: [MVC.Middleware.Type] {
        return [AuthorizationMiddleware.self]
    }

    static func setup(router: Router<TestController>) throws {
        router.route(get: "/user", authorizing: .user, to: user)
        router.route(get: "/admin", authorizing: .claim("admin"), to: admin)
    }

    let context: Context

    init(_ context: Context) {
        self.context = context
    }

    func user() -> String {
        return context.user?.name ?? "error"
    }

    func admin() -> String {
        return context.user?.name ?? "error"
    }
}

test.case("Middleware") {
    try Services.shared.register(
        transient: TestAuthorization.self,
        as: AuthorizationProtocol.self)

    let application = Application()
    try application.addController(TestController.self)

    let userRequest = Request(url: "/user?token=u", method: .get)
    let userResponse = try await application.process(userRequest)
    expect(userResponse.status == .ok)
    expect(userResponse.string == "user")

    let adminRequest = Request(url: "/admin", method: .get)
    let adminResponse = try await application.process(adminRequest)
    expect(adminResponse.status == .unauthorized)
    expect(adminResponse.string == "login required")

    let adminRequest2 = Request(url: "/admin?token=u", method: .get)
    let adminResponse2 = try await application.process(adminRequest2)
    expect(adminResponse2.status == .unauthorized)
    expect(adminResponse2.string == "access denied")

    let adminRequest3 = Request(url: "/admin?token=a", method: .get)
    let adminResponse3 = try await application.process(adminRequest3)
    expect(adminResponse3.status == .ok)
    expect(adminResponse3.string == "admin")
}

test.run()
