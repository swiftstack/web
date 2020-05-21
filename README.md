# Web

Web Framework

Key features:
* [Fast as hell](#fast-as-hell)
* [2 levels of abstraction](#2-levels-of-abstraction)
* [Simple asynchronous API](#simple-asynchronous-api)
* [Built-in Dependency Injector](#built-in-dependency-injector)

## Package.swift

```swift
.package(url: "https://github.com/swift-stack/web.git", .branch("dev"))
```

### Fast as hell

About 80k rps on `single core` (i7 4gen, docker) using [Fiber](http://github.com/swift-stack/fiber).<br>

```bash
(docker) wrk -t1 -c128 -d5 http://0.0.0.0:8080/plaintext
Running 5s test @ http://0.0.0.0:8080/plaintext
  1 threads and 128 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.64ms  310.35us   3.70ms   83.52%
    Req/Sec    78.43k     8.95k   93.04k    76.00%
  390020 requests in 5.10s, 28.64MB read
Requests/sec:  76500.26
Transfer/sec:      5.62MB
```

### 2 levels of abstraction

HTTP.Application - Simple API with minimum overhead<br>
MVC.Application - Convenience API: Controller, Context, DependencyInjector<br>

Both API levels have built-in `Request->Model`, `Model->Response` coders.<br/>

Bootstrap.swift
```swift
import HTTP
import Web

struct WikiApplication: Bootstrap {
    func configure(services: Services) throws {
        try services.register(
            singleton: InMemoryWikiRepository.self,
            as: WikiRepository.self)
    }

    func configure(application: MVC.Application) throws {
        try application.addController(WikiController.self)
    }

    func configure(application: HTTP.Application) throws {
        application.addHelloWorldRoute()
    }
}
```

WikiController.swift
```swift
import HTTP
import Web

public final class WikiController: Controller, InjectService {
    let repository: WikiRepository

    public init(_ repository: WikiRepository) {
        self.repository = repository
    }

    public static func setup(router: ControllerRouter<WikiController>) throws {
        router.route(get: "/:lang/:word", to: getDescription)
    }

    struct GetDescription: Decodable { let lang, work: String }
    struct Description: Encodable { let title, body: String }

    func getDescription(request: GetDescription) throws -> Description {
        guard let description = repository.search(request) else {
            throw HTTP.Error.notFound
        }
        return description
    }
}
```

HelloWorld.swift
```swift
import HTTP

extension Application {
    func addHelloWorldRoute() {
        route(get: "/plaintext") { request in
            return Response(string: "Hello, World")
        }
    }
}
```

### Simple Asynchronous API

All the modules built on top of [Async](http://github.com/swift-stack/async) which allows us to code without callbacks.<br>
The API is easy to use, easy to read and easy to update to `async/await` in the future.

main.swift
```swift
import Log
import Fiber
import Web

async.use(Fiber.self)

async.task {
    do {
        let application = try WebHost(bootstrap: WikiApplication())
        try application.run(at: "0.0.0.0", on: 8080)
    } catch {
        Log.critical(String(describing: error))
    }
}

async.loop.run()
```

### Built-in Dependency Injector

You can inject up to 6 services (out of the box).<br>
The service can be either Context or :Injectable.

NOTE: the ininializer arguments must have no labels.

```swift
import Web

final class SimpleController: Controller, Inject2Services {
    let context: Context
    let repository: SomeRepository

    init(_ context: Context, _ repository: SomeRepository) {
        self.context = context
        self.repository = repository
    }
}
```

singleton - shared instance per application<br>
transient - new instance per request<br>

```swift
let services = Servises.shared

services.register(
    singleton: MyImplementation.self,
    as: SomeProtocol.self)

services.register(
    transient: MyImplementation.self,
    as: SomeProtocol.self)

services.register(singleton: SomeProtocol.self) {
    return MyImplementation()
}

services.register(transient: SomeProtocol.self) {
    return MyImplementation()
}
```
