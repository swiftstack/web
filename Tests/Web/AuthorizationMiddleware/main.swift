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
        context.response.body = .output("login required")
    }

    func accessDenied(context: Context) {
        context.response = Response(status: .unauthorized)
        context.response.body = .output("access denied")
    }
}

final class TestController: Controller, InjectService {
    static var middleware: [any MVC.Middleware.Type] {
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

test("Middleware") {
    try Services.shared.register(
        transient: TestAuthorization.self,
        as: (any AuthorizationProtocol).self)

    let application = Application()
    try application.addController(TestController.self)

    let userRequest = Request(url: "/user?token=u", method: .get)
    let userResponse = try await application.process(userRequest)
    expect(userResponse.status == .ok)
    expect(try await userResponse.readBody(as: UTF8.self) == "user")

    let adminRequest = Request(url: "/admin", method: .get)
    let adminResponse = try await application.process(adminRequest)
    expect(adminResponse.status == .unauthorized)
    expect(try await adminResponse.readBody(as: UTF8.self) == "login required")

    let adminRequest2 = Request(url: "/admin?token=u", method: .get)
    let adminResponse2 = try await application.process(adminRequest2)
    expect(adminResponse2.status == .unauthorized)
    expect(try await adminResponse2.readBody(as: UTF8.self) == "access denied")

    let adminRequest3 = Request(url: "/admin?token=a", method: .get)
    let adminResponse3 = try await application.process(adminRequest3)
    expect(adminResponse3.status == .ok)
    expect(try await adminResponse3.readBody(as: UTF8.self) == "admin")
}

await run()
