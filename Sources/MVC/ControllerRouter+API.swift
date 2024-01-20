/************************/
/** Convenience routes **/
/************************/

import HTTP
public typealias ApiResult = HTTP.ApiResult

// MARK: () -> ApiResult

extension Router {

    // MARK: GET

    public func route(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: HEAD

    public func route(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: POST

    public func route(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: PUT

    public func route(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: DELETE

    public func route(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: OPTIONS

    public func route(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: ALL

    public func route(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> ApiResult
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }
}

// MARK: () -> Encodable

extension Router {

    // MARK: GET

    public func route<Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: HEAD

    public func route<Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: POST

    public func route<Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: PUT

    public func route<Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: DELETE

    public func route<Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: OPTIONS

    public func route<Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: ALL

    public func route<Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable, Result: Encodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Result
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }
}

// MARK: () -> Void

extension Router {

    // MARK: GET

    public func route(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        get path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.get],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: HEAD

    public func route(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        head path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.head],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: POST

    public func route(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        post path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.post],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: PUT

    public func route(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        put path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.put],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: DELETE

    public func route(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        delete path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.delete],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: OPTIONS

    public func route(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        options path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.options],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    // MARK: ALL

    public func route(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> () throws -> Void
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }

    public func route<URLMatch: Decodable, Model: Decodable>(
        all path: String,
        through middleware: [Middleware.Type] = [],
        authorizing authorization: Authorization? = nil,
        to handler: @escaping (T) -> (URLMatch, Model) throws -> Void
    ) {
        route(
            path: path,
            methods: [.all],
            authorization: authorization,
            middleware: middleware,
            handler: handler)
    }
}
