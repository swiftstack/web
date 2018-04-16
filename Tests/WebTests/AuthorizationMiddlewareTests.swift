import Test
@testable import MVC
@testable import Web

class AuthorizationMiddlewareTests: TestCase {
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

    func testMiddleware() {
        scope {
            try Services.shared.register(
                transient: TestAuthorization.self,
                as: AuthorizationProtocol.self)

            let application = Application()
            try application.addController(TestController.self)

            let userRequest = Request(url: "/user?token=u", method: .get)
            let userResponse = try application.process(userRequest)
            assertEqual(userResponse.status, .ok)
            assertEqual(userResponse.string, "user")

            let adminRequest = Request(url: "/admin", method: .get)
            let adminResponse = try application.process(adminRequest)
            assertEqual(adminResponse.status, .unauthorized)
            assertEqual(adminResponse.string, "login required")

            let adminRequest2 = Request(url: "/admin?token=u", method: .get)
            let adminResponse2 = try application.process(adminRequest2)
            assertEqual(adminResponse2.status, .unauthorized)
            assertEqual(adminResponse2.string, "access denied")

            let adminRequest3 = Request(url: "/admin?token=a", method: .get)
            let adminResponse3 = try application.process(adminRequest3)
            assertEqual(adminResponse3.status, .ok)
            assertEqual(adminResponse3.string, "admin")
        }
    }
}
