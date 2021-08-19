import Test
@testable import MVC
@testable import Web

class CookiesMiddlewareTests: TestCase {
    func testMiddleware() {
        final class TestController: Controller, InjectService {
            static var middleware: [MVC.Middleware.Type] {
                return [CookiesMiddleware.self]
            }

            static func setup(router: Router<TestController>) throws {
                router.route(get: "/first", to: first)
                router.route(get: "/second", to: second)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func first() -> String {
                context.cookies["cookie-name"] = "cookie-value"
                return "ok"
            }

            func second() -> String? {
                return context.cookies["cookie-name"]
            }
        }

        scope {
            try Services.shared.register(
                singleton: InMemoryCookiesStorage.self,
                as: CookiesStorage.self)

            let application = Application()
            try application.addController(TestController.self)

            let firstRequest = Request(url: "/first", method: .get)
            let firstResponse = try application.process(firstRequest)
            expect(firstResponse.cookies.count == 1)
            guard let cookie = firstResponse.cookies.first else {
                return
            }
            expect(cookie.name == "swiftstack-cookies")
            expect(!cookie.value.isEmpty)

            let secondRequest = Request(url: "/second", method: .get)
            var secondResponse = try application.process(secondRequest)
            expect(secondResponse.status == .noContent)
            expect(secondResponse.string == nil)

            secondRequest.cookies.append(cookie)
            secondResponse = try application.process(secondRequest)
            expect(secondResponse.string == "cookie-value")
        }
    }
}
