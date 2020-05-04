import Test
@testable import MVC

class MiddlewareTests: TestCase {
    func testMiddleware() {
        struct TestMiddleware: MVC.Middleware {
            public static func chain(
                with middleware: @escaping (Context) throws -> Void
            ) -> (Context) throws -> Void {
                return { context in
                    try middleware(context)
                    context.response.string = "success"
                    context.response.headers["Custom-Header"] = "Middleware"
                }
            }
        }

        final class TestController: Controller, InjectService {
            static var middleware: [MVC.Middleware.Type] {
                return [TestMiddleware.self]
            }

            static func setup(router: Router<TestController>) throws {
                router.route(get: "/middleware", to: handler)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func handler() -> String {
                context.response.headers["Controller"] = "OK"
                return "error"
            }
        }

        scope {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/middleware", method: .get)
            let response = try application.process(request)

            expect(response.headers["Custom-Header"] == "Middleware")
        }
    }

    func testMiddlewareOrder() {
        struct FirstMiddleware: MVC.Middleware {
            public static func chain(
                with middleware: @escaping (Context) throws -> Void
            ) -> (Context) throws -> Void {
                return { context in
                    try middleware(context)
                    context.response.headers["Middleware"] = "first"
                    context.response.headers["FirstMiddleware"] = "true"
                }
            }
        }

        struct SecondMiddleware: MVC.Middleware {
            public static func chain(
                with middleware: @escaping (Context) throws -> Void
            ) -> (Context) throws -> Void {
                return { context in
                    try middleware(context)
                    context.response.headers["Middleware"] = "second"
                    context.response.headers["SecondMiddleware"] = "true"
                }
            }
        }

        final class TestController: Controller, InjectService {
            static var middleware: [MVC.Middleware.Type] {
                return [FirstMiddleware.self, SecondMiddleware.self]
            }

            static func setup(router: Router<TestController>) throws {
                router.route(get: "/middleware", to: handler)
            }

            let context: Context

            init(_ context: Context) {
                self.context = context
            }

            func handler() -> String {
                context.response.headers["Controller"] = "OK"
                return "error"
            }
        }

        scope {
            let application = Application()
            try application.addController(TestController.self)

            let request = Request(url: "/middleware", method: .get)
            let response = try application.process(request)

            expect(response.headers["FirstMiddleware"] == "true")
            expect(response.headers["SecondMiddleware"] == "true")
            expect(response.headers["Middleware"] == "first")
        }
    }
}
