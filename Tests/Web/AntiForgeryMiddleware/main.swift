import Test
@testable import MVC
@testable import Web

final class TestController: Controller, InjectService {
    let context: Context

    init(_ context: Context) {
        self.context = context
    }

    static func setup(router: Router<TestController>) throws {
        router.route(get: "/", to: index)
        router.route(post: "/", to: post)
    }

    func index() -> String {
        return context.cookies[AntiForgeryMiddleware.tokenCookieName]
            ?? "error"
    }

    func post() -> String {
        return "post ok"
    }
}

func makeApplication() throws -> Application {
    try Services.shared.register(
        singleton: InMemoryCookiesStorage.self,
        as: CookiesStorage.self)

    let application = Application(middleware: [
        CookiesMiddleware.self,
        AntiForgeryMiddleware.self])
    try application.addController(TestController.self)

    return application
}

test("Token") {
    let application = try makeApplication()
    let request = Request(url: "/", method: .get)
    let response = try await application.process(request)
    expect(response.status == .ok)
    expect(try await response.readBody(as: UTF8.self).isEmpty == false)
    expect(try await response.readBody(as: UTF8.self) != "error")
}

test("PostWithoutTokens") {
    let application = try makeApplication()
    let request = Request(url: "/", method: .post)
    let response = try await application.process(request)
    expect(response.status == .badRequest)
    expect(try await response.readBody(as: UTF8.self).isEmpty)
}

test("PostWithSingleToken") {
    let application = try makeApplication()

    let initialResponse = try await application.process(
        Request(url: "/", method: .get))

    let request = Request(url: "/", method: .post)
    request.cookies = initialResponse.cookies.map { $0.cookie }
    let response = try await application.process(request)

    expect(response.status == .badRequest)
    expect(try await response.readBody(as: UTF8.self).isEmpty)
}

test("PostWithTokens") {
    let application = try makeApplication()

    let initialResponse = try await application.process(
        Request(url: "/", method: .get))

    let request = Request(url: "/", method: .post)
    request.cookies = initialResponse.cookies.map { $0.cookie }
    request.headers["X-CSRF-Token"] = try await initialResponse.readBody(as: UTF8.self)
    let response = try await application.process(request)
    expect(response.status == .ok)
    expect(try await response.readBody(as: UTF8.self) == "post ok")
}

await run()
