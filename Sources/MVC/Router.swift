import HTTP

public class Router<T: Controller> {
    let basePath: String
    @usableFromInline let middleware: [Middleware.Type]
    @usableFromInline let authorization: Authorization
    var constructor: (Context) throws -> T
    let services: Services

    public typealias Route = MVC.Application.Route
    public typealias MethodSet = HTTP.Router.MethodSet

    var routes: [Route] = []

    public init(
        basePath: String,
        middleware: [Middleware.Type],
        authorization: Authorization,
        services: Services,
        controllerConstructor constructor: @escaping (Context) throws -> T
    ) {
        self.basePath = basePath
        self.middleware = middleware
        self.authorization = authorization
        self.constructor = constructor
        self.services = services
    }

    func chainMiddleware(
        _ middleware: [Middleware.Type],
        with handler: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void {
        var handler = handler
        for next in middleware.reversed() {
            handler = next.chain(with: handler)
        }
        return handler
    }

    public func registerRoute(
        path: String,
        methods: MethodSet,
        handler: @escaping RequestHandler
    ) {
        routes.append(Route(
            path: path,
            methods: methods,
            handler: handler
        ))
    }

    // Boilerplate for convenience routes:
    //
    // available handlers:
    //
    // () -> ApiResult
    // () -> Encodable
    // () -> Void
    // (URLMatch or Model) -> ApiResult
    // (URLMatch or Model) -> Encodable
    // (URLMatch or Model) -> Void
    // (URLMatch, Model) -> ApiResult
    // (URLMatch, Model) -> Encodable
    // (URLMatch, Model) -> Void
    //
    // pseudocode:
    //
    // application.route { request, ... in
    //     let context = Context(request: request, services: self.services)
    //
    //     let response = callMiddlewareChain(last: { context in
    //         let controller = try self.constructor(context)
    //         let handler = handlerConstructor(controller)
    //
    //         let result = controllerHandler(...)
    //
    //         let request = context.request
    //         let response = context.response
    //         try Coder.updateRespone(response, for: request, encoding: result)
    //         return response
    //     })
    //     return context.response
    // }


    // MARK: No arguments

    @usableFromInline
    func makeMiddleware(
        for path: String,
        wrapping accessor: @escaping (T) -> () throws -> ApiResult
    ) -> (Context) throws -> Void {
        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)
            let result = try handler()
            try Coder.updateRespone(
                context.response, for: context.request, with: result)
        }
    }

    @usableFromInline
    func makeMiddleware(
        for path: String,
        wrapping accessor: @escaping (T) -> () throws -> Encodable
    ) -> (Context) throws -> Void {
        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)
            let result = try handler()
            switch result {
            case let value as Optional<Any> where value == nil:
                context.response.status = .noContent
                context.response.body = .none
            default:
                try Coder.updateRespone(
                    context.response,
                    for: context.request,
                    with: .object(result))
            }
        }
    }

    @usableFromInline
    func makeMiddleware(
        for path: String,
        wrapping accessor: @escaping (T) -> () throws -> Void
    ) -> (Context) throws -> Void {
        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)
            try handler()
        }
    }

    // MARK: One argument, URLMatch or Model

    @usableFromInline
    func makeMiddleware<Model: Decodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (Model) throws -> ApiResult
    ) -> (Context) throws -> Void {
        let urlMatcher = URLParamMatcher(path)

        if urlMatcher.params.count > 0 {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let request = context.request
                let response = context.response

                let values = urlMatcher.match(from: context.request.url.path)
                let match = try Model(from: KeyValueDecoder(values))
                let result = try handler(match)
                try Coder.updateRespone(response, for: request, with: result)
            }
        } else {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let request = context.request
                let response = context.response

                let model = try Coder.decode(Model.self, from: request)
                let result = try handler(model)
                try Coder.updateRespone(response, for: request, with: result)
            }
        }
    }

    @usableFromInline
    func makeMiddleware<Model: Decodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (Model) throws -> Encodable
    ) -> (Context) throws -> Void {
        let urlMatcher = URLParamMatcher(path)

        if urlMatcher.params.count > 0 {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let values = urlMatcher.match(from: context.request.url.path)
                let match = try Model(from: KeyValueDecoder(values))
                let result = try handler(match)
                switch result {
                case let value as Optional<Any> where value == nil:
                    context.response.status = .noContent
                    context.response.body = .none
                default:
                    try Coder.updateRespone(
                        context.response,
                        for: context.request,
                        with: .object(result))
                }
            }
        } else {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let model = try Coder.decode(Model.self, from: context.request)
                let result = try handler(model)
                switch result {
                case let value as Optional<Any> where value == nil:
                    context.response.status = .noContent
                    context.response.body = .none
                default:
                    try Coder.updateRespone(
                        context.response,
                        for: context.request,
                        with: .object(result))
                }
            }
        }
    }

    @usableFromInline
    func makeMiddleware<Model: Decodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (Model) throws -> Void
    ) -> (Context) throws -> Void {
        let urlMatcher = URLParamMatcher(path)

        if urlMatcher.params.count > 0 {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let values = urlMatcher.match(from: context.request.url.path)
                let match = try Model(from: KeyValueDecoder(values))
                try handler(match)
            }
        } else {
            return { context in
                let controller = try self.constructor(context)
                let handler = accessor(controller)

                let request = context.request

                let model = try Coder.decode(Model.self, from: request)
                try handler(model)
            }
        }
    }

    @usableFromInline
    func makeMiddleware<Match: Decodable, Model: Decodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (Match, Model) throws -> ApiResult
    ) -> (Context) throws -> Void {
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)

            let request = context.request
            let response = context.response

            let values = urlMatcher.match(from: request.url.path)
            let match = try Match(from: KeyValueDecoder(values))
            let model = try Coder.decode(Model.self, from: request)
            let result = try handler(match, model)
            try Coder.updateRespone(response, for: request, with: result)
        }
    }

    @usableFromInline
    func makeMiddleware<Match: Decodable, Model: Decodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (Match, Model) throws -> Encodable
    ) -> (Context) throws -> Void {
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)

            let request = context.request
            let response = context.response

            let values = urlMatcher.match(from: request.url.path)
            let match = try Match(from: KeyValueDecoder(values))
            let model = try Coder.decode(Model.self, from: request)
            let result = try handler(match, model)
            try Coder.updateRespone(
                response,
                for: request,
                with: .object(result))
        }
    }

    @usableFromInline
    func makeMiddleware<URLMatch: Decodable, Model: Decodable>(
        for path: String,
        wrapping accessor: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) -> (Context) throws -> Void {
        let urlMatcher = URLParamMatcher(path)

        guard urlMatcher.params.count > 0 else {
            fatalError("invalid url mask, more than 0 arguments were expected")
        }

        return { context in
            let controller = try self.constructor(context)
            let handler = accessor(controller)

            let values = urlMatcher.match(from: context.request.url.path)
            let match = try URLMatch(from: KeyValueDecoder(values))
            let model = try Coder.decode(Model.self, from: context.request)
            try handler(match, model)
        }
    }

    // controller handler <-> http handler

    @usableFromInline
    func makeHandler(
        through middleware: [Middleware.Type],
        to handler: @escaping (Context) throws -> Void,
        authorize authorization: Authorization
    ) -> RequestHandler {
        let middleware = self.middleware + middleware
        let chain = chainMiddleware(middleware, with: handler)

        return { (request: Request) throws -> Response in
            let context = Context(
                request: request,
                authorization: authorization,
                services: self.services)
            try chain(context)
            return context.response
        }
    }

    // MARK: Base routes

    @inlinable
    public func route(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> ApiResult
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization ?? self.authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }

    @inlinable
    public func route<Result: Encodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Result
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }

    @inlinable
    public func route(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> () throws -> Void
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }


    @inlinable
    public func route<Model: Decodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }

    @inlinable
    public func route<Model: Decodable, Result: Encodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Result
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }

    @inlinable
    public func route<Model: Decodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (Model) throws -> Void
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }


    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }

    @inlinable
    public func route<URLMatch: Decodable, Model: Decodable>(
        path: String,
        methods: MethodSet,
        authorization: Authorization?,
        middleware: [Middleware.Type] = [],
        handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        let handlerMiddleware = makeMiddleware(for: path, wrapping: handler)
        let authorization = authorization ?? self.authorization
        let handler = makeHandler(
            through: middleware,
            to: handlerMiddleware,
            authorize: authorization)
        registerRoute(path: path, methods: methods, handler: handler)
    }
}
