import Log
import HTTP
import FileSystem

extension RouterProtocol {
    public func serveStaticFiles(
        from basePath: String,
        including children: [String] = ["/*"],
        notFoundHandler: @escaping RequestHandler = { _ in return .notFound }
    ) {
        for path in children {
            route(get: path) { (request: Request) -> Response in
                if request.url.path.last == "/" {
                    return try await notFoundHandler(request)
                }
                let file = try File(at: basePath + request.url.path)
                guard file.isExists else {
                    return try await notFoundHandler(request)
                }
                return try await Response(contentOf: file)
            }
        }
    }
}

extension Response {
    convenience
    public init(contentOf file: File) async throws {
        self.init(status: .ok)
        let stream = try file.open(flags: [.read]).inputStream
        self.body = .output(try await stream.readUntilEnd())
        self.contentType = ContentType(for: file)
    }
}

extension ContentType {
    init(for file: File) {
        switch file.name.extension {
        case .some(let ext): self = ContentType(forExtension: ext)
        case .none: self = .stream
        }
    }

    init<T: StringProtocol>(forExtension extension: T) {
        switch `extension` {
        case "html": self = ContentType(mediaType: .text(.html))!
        case "css": self = ContentType(mediaType: .text(.css))!
        case "js": self = ContentType(mediaType: .application(.javascript))!
        case "png": self = ContentType(mediaType: .image(.png))!
        case "svg": self = ContentType(mediaType: .image(.svg))!
        case "jpg", "jpeg": self = ContentType(mediaType: .image(.jpeg))!
        default: self = ContentType(mediaType: .application(.stream))!
        }
    }
}
