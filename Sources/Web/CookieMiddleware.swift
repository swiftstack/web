import class HTTP.Response
import struct HTTP.Cookie
import struct Foundation.Date

public class CookiesMiddleware: Middleware {
    public static var cookiesName: String = "swift-stack-cookies"

    public static func chain(
        with middleware: @escaping (Context) throws -> Void
    ) -> (Context) throws -> Void {
        return { context in
            let storage = try context.services.resolve(CookiesStorage.self)

            if let token = context.request.cookies[cookiesName],
                let cookies = try storage.get(hash: token) {
                    context.cookies = cookies
            }

            try middleware(context)

            guard context.cookies.hasChanges else {
                return
            }

            guard context.cookies.count > 0 else {
                try storage.delete(hash: context.cookies.hash)
                context.response.cookies.append(Cookie(
                    name: cookiesName,
                    value: "",
                    expires: Date(timeIntervalSince1970: 0)))
                return
            }

            try storage.upsert(cookies: context.cookies)
            context.response.cookies.append(Cookie(
                name: cookiesName,
                value: context.cookies.hash))
        }
    }
}

// FIXME:

extension Array where Element == Cookie {
    public subscript(_ name: String) -> String? {
        get {
            return first { $0.name == name }?.value
        }
        mutating set {
            guard let index = index(where: { $0.name == name }) else {
                if let newValue = newValue {
                    self.append(Cookie(name: name, value: newValue))
                }
                return
            }
            if let newValue = newValue {
                self[index] = Cookie(name: name, value: newValue)
                return
            } else {
                self.remove(at: index)
                return
            }
        }
    }
}
