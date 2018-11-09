import HTTP

public class Application {
    public struct Route {
        public let path: String
        public let methods: MethodSet
        public let handler: RequestHandler

        public init(
            path: String,
            methods: HTTP.Router.MethodSet,
            handler: @escaping RequestHandler)
        {
            self.path = path
            self.methods = methods
            self.handler = handler
        }
    }

    public var basePath: String
    public var middleware: [MVC.Middleware.Type]
    public typealias MethodSet = HTTP.Router.MethodSet

    public private(set) var routes = [Route]()

    public init(basePath: String = "", middleware: [Middleware.Type] = []) {
        self.basePath = basePath
        self.middleware = middleware
    }
}

extension Application {
    public func registerRoute(
        path: String,
        methods: MethodSet,
        handler: @escaping RequestHandler
    ) {
        routes.append(Route(
            path: self.basePath + path,
            methods: methods,
            handler: handler
        ))
    }

    // @testable
    func process(_ request: Request) throws -> Response {
        let router = HTTP.Router()
        router.addApplication(self)
        return try router.process(request)
    }
}

extension Application {
    func addController<C: Controller>(
        _ controller: C.Type,
        constructor: @escaping (Context) throws -> C
    ) throws {
        let router = Router<C>(
            basePath: C.basePath,
            middleware: self.middleware + C.middleware,
            authorization: C.authorization,
            services: Services.shared,
            controllerConstructor: constructor
        )
        try C.setup(router: router)

        for route in router.routes {
            self.registerRoute(
                path: route.path,
                methods: route.methods,
                handler: route.handler)
        }
    }
}

extension RouterProtocol {
    public func addApplication(_ application: MVC.Application) {
        for route in application.routes {
            self.registerRoute(
                path: route.path,
                methods: route.methods,
                middleware: [],
                handler: route.handler)
        }
    }
}

extension RouterProtocol {
    public func addApplication(
        basePath: String = "", 
        middleware: [Middleware.Type] = [],
        configure: (MVC.Application) throws -> Void) rethrows
    {
        let application = MVC.Application(
            basePath: basePath, 
            middleware: middleware)
        try configure(application)
        addApplication(application)
    }
}
