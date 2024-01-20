import Test
@testable import MVC

protocol StringResult: Inject {
    var string: String { get }
}

extension StringResult {
    var string: String {
        // one two three four five six
        return "\(Self.self)".dropFirst("TestService".count).lowercased()
    }
}

protocol ServiceOne: StringResult {}
protocol ServiceTwo: StringResult {}
protocol ServiceThree: StringResult {}
protocol ServiceFour: StringResult {}
protocol ServiceFive: StringResult {}
protocol ServiceSix: StringResult {}

final class TestServiceOne: ServiceOne {}
final class TestServiceTwo: ServiceTwo {}
final class TestServiceThree: ServiceThree {}
final class TestServiceFour: ServiceFour {}
final class TestServiceFive: ServiceFive {}
final class TestServiceSix: ServiceSix {}

test("Injectable") {
    final class TestController: Controller, Inject {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        func fetch() -> String {
            return "fetch ok"
        }
    }

    await scope {
        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "fetch ok")
    }
}

test("InjectService") {
    final class TestController: Controller, InjectService {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        let serviceOne: any ServiceOne

        init(_ serviceOne: any ServiceOne) {
            self.serviceOne = serviceOne
        }

        func fetch() -> String {
            return serviceOne.string
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "one")
    }
}

test("Inject2Services") {
    final class TestController: Controller, Inject2Services {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        let serviceOne: any ServiceOne
        let serviceTwo: any ServiceTwo

        init(_ serviceOne: any ServiceOne, _ serviceTwo: any ServiceTwo) {
            self.serviceOne = serviceOne
            self.serviceTwo = serviceTwo
        }

        func fetch() -> String {
            return [
                serviceOne.string,
                serviceTwo.string
            ].joined(separator: " ")
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)
        try Services.shared.register(
            transient: TestServiceTwo.self,
            as: (any ServiceTwo).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "one two")
    }
}

test("Inject3Services") {
    final class TestController: Controller, Inject3Services {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        let serviceOne: any ServiceOne
        let serviceTwo: any ServiceTwo
        let serviceThree: any ServiceThree

        init(
            _ serviceOne: any ServiceOne,
            _ serviceTwo: any ServiceTwo,
            _ serviceThree: any ServiceThree
        ) {
            self.serviceOne = serviceOne
            self.serviceTwo = serviceTwo
            self.serviceThree = serviceThree
        }

        func fetch() -> String {
            return [
                serviceOne.string,
                serviceTwo.string,
                serviceThree.string
            ].joined(separator: " ")
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)
        try Services.shared.register(
            transient: TestServiceTwo.self,
            as: (any ServiceTwo).self)
        try Services.shared.register(
            transient: TestServiceThree.self,
            as: (any ServiceThree).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "one two three")
    }
}

test("Inject4Services") {
    final class TestController: Controller, Inject4Services {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        let serviceOne: any ServiceOne
        let serviceTwo: any ServiceTwo
        let serviceThree: any ServiceThree
        let serviceFour: any ServiceFour

        init(
            _ serviceOne: any ServiceOne,
            _ serviceTwo: any ServiceTwo,
            _ serviceThree: any ServiceThree,
            _ serviceFour: any ServiceFour
        ) {
            self.serviceOne = serviceOne
            self.serviceTwo = serviceTwo
            self.serviceThree = serviceThree
            self.serviceFour = serviceFour
        }

        func fetch() -> String {
            return [
                serviceOne.string,
                serviceTwo.string,
                serviceThree.string,
                serviceFour.string,
            ].joined(separator: " ")
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)
        try Services.shared.register(
            transient: TestServiceTwo.self,
            as: (any ServiceTwo).self)
        try Services.shared.register(
            transient: TestServiceThree.self,
            as: (any ServiceThree).self)
        try Services.shared.register(
            transient: TestServiceFour.self,
            as: (any ServiceFour).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "one two three four")
    }
}

test("Inject5Services") {
    final class TestController: Controller, Inject5Services {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        let serviceOne: any ServiceOne
        let serviceTwo: any ServiceTwo
        let serviceThree: any ServiceThree
        let serviceFour: any ServiceFour
        let serviceFive: any ServiceFive

        init(
            _ serviceOne: any ServiceOne,
            _ serviceTwo: any ServiceTwo,
            _ serviceThree: any ServiceThree,
            _ serviceFour: any ServiceFour,
            _ serviceFive: any ServiceFive
        ) {
            self.serviceOne = serviceOne
            self.serviceTwo = serviceTwo
            self.serviceThree = serviceThree
            self.serviceFour = serviceFour
            self.serviceFive = serviceFive
        }

        func fetch() -> String {
            return [
                serviceOne.string,
                serviceTwo.string,
                serviceThree.string,
                serviceFour.string,
                serviceFive.string
            ].joined(separator: " ")
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)
        try Services.shared.register(
            transient: TestServiceTwo.self,
            as: (any ServiceTwo).self)
        try Services.shared.register(
            transient: TestServiceThree.self,
            as: (any ServiceThree).self)
        try Services.shared.register(
            transient: TestServiceFour.self,
            as: (any ServiceFour).self)
        try Services.shared.register(
            transient: TestServiceFive.self,
            as: (any ServiceFive).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "one two three four five")
    }
}

test("Inject6Services") {
    final class TestController: Controller, Inject6Services {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: fetch)
        }

        let serviceOne: any ServiceOne
        let serviceTwo: any ServiceTwo
        let serviceThree: any ServiceThree
        let serviceFour: any ServiceFour
        let serviceFive: any ServiceFive
        let serviceSix: any ServiceSix

        init(
            _ serviceOne: any ServiceOne,
            _ serviceTwo: any ServiceTwo,
            _ serviceThree: any ServiceThree,
            _ serviceFour: any ServiceFour,
            _ serviceFive: any ServiceFive,
            _ serviceSix: any ServiceSix
        ) {
            self.serviceOne = serviceOne
            self.serviceTwo = serviceTwo
            self.serviceThree = serviceThree
            self.serviceFour = serviceFour
            self.serviceFive = serviceFive
            self.serviceSix = serviceSix
        }

        func fetch() -> String {
            return [
                serviceOne.string,
                serviceTwo.string,
                serviceThree.string,
                serviceFour.string,
                serviceFive.string,
                serviceSix.string
            ].joined(separator: " ")
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)
        try Services.shared.register(
            transient: TestServiceTwo.self,
            as: (any ServiceTwo).self)
        try Services.shared.register(
            transient: TestServiceThree.self,
            as: (any ServiceThree).self)
        try Services.shared.register(
            transient: TestServiceFour.self,
            as: (any ServiceFour).self)
        try Services.shared.register(
            transient: TestServiceFive.self,
            as: (any ServiceFive).self)
        try Services.shared.register(
            transient: TestServiceSix.self,
            as: (any ServiceSix).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "one two three four five six")
    }
}

test("InjectContext") {
    final class TestController: Controller, InjectService {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: handler)
        }

        let context: Context

        init(_ context: Context) {
            self.context = context
        }

        func handler() -> String {
            return context.request.headers["test context"] ?? "error"
        }
    }

    await scope {
        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        request.headers["test context"] = "test context ok"

        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "test context ok")
    }
}

test("InjectContextService") {
    final class TestController: Controller, Inject2Services {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: handler)
        }

        let context: Context
        let serviceOne: any ServiceOne

        init(_ context: Context, _ serviceOne: any ServiceOne) {
            self.context = context
            self.serviceOne = serviceOne
        }

        func handler() -> String {
            let header = context.request.headers["test context"] ?? "error"
            return [header, serviceOne.string].joined(separator: " ")
        }
    }

    await scope {
        try Services.shared.register(
            transient: TestServiceOne.self,
            as: (any ServiceOne).self)

        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        request.headers["test context"] = "test context ok"

        let response = try await application.process(request)
        expect(try await response.readBody(as: UTF8.self) == "test context ok one")
    }
}

test("ContextResponse") {
    final class TestController: Controller, InjectService {
        static func setup(router: Router<TestController>) throws {
            router.route(get: "/", to: handler)
        }

        let context: Context

        init(_ context: Context) {
            self.context = context
        }

        func handler() -> String {
            context.response.headers["controller"] = "ok"
            return "ok"
        }
    }

    await scope {
        let application = Application()
        try application.addController(TestController.self)

        let request = Request(url: "/", method: .get)
        request.headers["test context"] = "test context ok"

        let response = try await application.process(request)
        expect(response.headers["controller"] == "ok")
    }
}

await run()
