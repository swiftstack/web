public class Services {
    enum Error: Swift.Error {
        case typeMismatch(type: Any.Type, proto: Any.Type)
        case typeNotFound(Any.Type)
    }

    public static let shared = Services()

    enum Lifetime {
        case singleton(Any)
        case transient((Services) throws -> Any)
    }

    var values: [Int: Lifetime] = [:]

    @inline(__always)
    func id<T>(_ type: T.Type) -> Int {
        return unsafeBitCast(type, to: Int.self)
    }

    // MARK: Singleton

    public func register<T, P>(
        singleton proto: P.Type,
        _ constructor: () throws -> T
    ) throws {
        guard let instance = try constructor() as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Inject
    {
        guard let instance = try T() as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: InjectService
    {
        let one = try resolve(T.One.self)
        guard let instance = try T(one) as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Inject2Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        guard let instance = try T(one, two) as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Inject3Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        guard let instance = try T(one, two, three) as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Inject4Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        let four = try resolve(T.Four.self)
        guard let instance = try T(one, two, three, four) as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Inject5Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        let four = try resolve(T.Four.self)
        let five = try resolve(T.Five.self)
        guard let instance = try T(one, two, three, four, five) as? P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    public func register<T, P>(singleton type: T.Type, as proto: P.Type) throws
        where T: Inject6Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        let four = try resolve(T.Four.self)
        let five = try resolve(T.Five.self)
        let six = try resolve(T.Six.self)
        guard let instance = try T(one, two, three, four, five, six) as? P else
        {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .singleton(instance)
    }

    // MARK: Transient

    public func register<T, P>(
        transient proto: P.Type,
        _ constructor: @escaping () throws -> T
    ) throws {
        guard try constructor() is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { _ in return try constructor() }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Inject
    {
        guard try T() is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { _ in return try T() }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: InjectService
    {
        let one = try resolve(T.One.self)
        guard try T(one) is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { services in
            let one = try services.resolve(T.One.self)
            return try T(one)
        }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Inject2Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        guard try T(one, two) is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { services in
            let one = try services.resolve(T.One.self)
            return try T(one, two)
        }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Inject3Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        guard try T(one, two, three) is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { services in
            let one = try services.resolve(T.One.self)
            let two = try services.resolve(T.Two.self)
            let three = try services.resolve(T.Three.self)
            return try T(one, two, three)
        }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Inject4Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        let four = try resolve(T.Four.self)
        guard try T(one, two, three, four) is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { services in
            let one = try services.resolve(T.One.self)
            let two = try services.resolve(T.Two.self)
            let three = try services.resolve(T.Three.self)
            let four = try services.resolve(T.Four.self)
            return try T(one, two, three, four)
        }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Inject5Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        let four = try resolve(T.Four.self)
        let five = try resolve(T.Five.self)
        guard try T(one, two, three, four, five) is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { services in
            let one = try services.resolve(T.One.self)
            let two = try services.resolve(T.Two.self)
            let three = try services.resolve(T.Three.self)
            let four = try services.resolve(T.Four.self)
            let five = try services.resolve(T.Five.self)
            return try T(one, two, three, four, five)
        }
    }

    public func register<T, P>(transient type: T.Type, as proto: P.Type) throws
        where T: Inject6Services
    {
        let one = try resolve(T.One.self)
        let two = try resolve(T.Two.self)
        let three = try resolve(T.Three.self)
        let four = try resolve(T.Four.self)
        let five = try resolve(T.Five.self)
        let six = try resolve(T.Six.self)
        guard try T(one, two, three, four, five, six) is P else {
            throw Error.typeMismatch(type: T.self, proto: P.self)
        }
        values[id(proto)] = .transient { services in
            let one = try services.resolve(T.One.self)
            let two = try services.resolve(T.Two.self)
            let three = try services.resolve(T.Three.self)
            let four = try services.resolve(T.Four.self)
            let five = try services.resolve(T.Five.self)
            let six = try services.resolve(T.Six.self)
            return try T(one, two, three, four, five, six)
        }
    }

    public func resolve<P>(_ proto: P.Type) throws -> P {
        guard let lifetime = values[id(proto)] else {
            throw Error.typeNotFound(P.self)
        }
        switch lifetime {
        case .singleton(let instance): return instance as! P
        case .transient(let constructor): return try constructor(self) as! P
        }
    }
}

extension Services.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .typeMismatch(let type, let proto):
            return "type \(type) must conform to \(proto)"
        case .typeNotFound(let type):
            return "type \(type) is not registered"
        }
    }
}
