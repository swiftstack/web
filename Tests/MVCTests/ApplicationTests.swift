import Test
@testable import HTTP
@testable import MVC

class ApplicationTests: TestCase {
    func testPartialUrl() {
        final class TestController: Controller, Inject {
            static func setup(router: MVC.Router<TestController>) throws {
                router.route(get: "/:name/id/:number", to: handler)
            }

            struct Page: Decodable {
                let name: String
                let number: Int
            }

            func handler(page: Page) -> String {
                return "\(page.name) - \(page.number)"
            }
        }

        scope {
            let application = HTTP.Application(basePath: "/api")
            let mvcApplication = MVC.Application(basePath: "/v1")
            try mvcApplication.addController(TestController.self)
            application.addApplication(mvcApplication)

            let request = Request(url: "/api/v1/news/id/2", method: .get)
            let response = try application.process(request)
            expect(response.status == .ok)
        }
    }

    func testConvenienceAPI() {
        final class TestController: Controller, Inject {
            static func setup(router: MVC.Router<TestController>) throws {
                router.route(get: "/test", to: handler)
            }
            
            func handler() -> String {
                return "ok"
            }
        }

        scope {
            let application = HTTP.Application(basePath: "/api")
            try application.addApplication(basePath: "/v1") { v1 in
                try v1.addController(TestController.self)
            }
            let request = Request(url: "/api/v1/test", method: .get)
            let response = try application.process(request)
            expect(response.status == .ok)
        }

        scope {
            let application = MVC.Application(basePath: "/api")
            try application.addApplication(basePath: "/v1") { v1 in
                try v1.addController(TestController.self)
            }
            let request = Request(url: "/api/v1/test", method: .get)
            let response = try application.process(request)
            expect(response.status == .ok)
        }
    }
}
