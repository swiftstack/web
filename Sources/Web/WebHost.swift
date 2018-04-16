import Log
import HTTP
@_exported import MVC

public protocol Bootstrap {
    var host: String { get }
    var port: Int { get }

    func configure(services: Services) throws
    func configure(application: MVC.Application) throws
    func configure(application: HTTP.Application) throws
    func configure(router: HTTP.Router) throws
}

public extension Bootstrap {
    var host: String { return "0.0.0.0" }
    var port: Int { return 8080 }

    func configure(services: Services) throws {}
    func configure(application: MVC.Application) throws {}
    func configure(application: HTTP.Application) throws {}
    func configure(router: HTTP.Router) throws {}
}

public struct WebHost {
    let server: Server
    let application: HTTP.Application

    public init(bootstrap: Bootstrap) throws {
        self.server = try Server(from: bootstrap)
        self.application = try HTTP.Application(from: bootstrap)
        server.addApplication(application)
        try bootstrap.configure(router: server.router)
    }

    public func run() throws {
        try server.start()
    }
}

extension HTTP.Application {
    convenience init(from bootstrap: Bootstrap) throws {
        self.init()

        try bootstrap.configure(services: Services.shared)
        try bootstrap.configure(application: self)

        let application = MVC.Application()
        try bootstrap.configure(application: application)
        addApplication(application)
    }
}

extension Server {
    convenience init(from bootstrap: Bootstrap) throws {
        try self.init(host: bootstrap.host, reusePort: bootstrap.port)
    }
}
