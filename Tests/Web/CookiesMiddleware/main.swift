import Test
@testable import MVC
@testable import Web

test.case("Middleware") {
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

    await scope {
        try Services.shared.register(
            singleton: InMemoryCookiesStorage.self,
            as: CookiesStorage.self)

        let application = Application()
        try application.addController(TestController.self)

        let firstRequest = Request(url: "/first", method: .get)
        let firstResponse = try await application.process(firstRequest)
        expect(firstResponse.cookies.count == 1)
        guard let setCookie = firstResponse.cookies.first else {
            return
        }
        expect(setCookie.cookie.name == "swift-stack-cookies")
        expect(!setCookie.cookie.value.isEmpty)

        let secondRequest = Request(url: "/second", method: .get)
        var secondResponse = try await application.process(secondRequest)
        expect(secondResponse.status == .noContent)
        expect(try await secondResponse.readBody(as: UTF8.self).isEmpty)

        secondRequest.cookies.append(setCookie.cookie)
        secondResponse = try await application.process(secondRequest)
        expect(try await secondResponse.readBody(as: UTF8.self) == "cookie-value")
    }
}

test.run()
