public protocol UserManager {
    func register(_ credentials: User.NewCredentials) throws -> User
    func login(_ credentials: User.Credentials) throws -> User
}

public final class DefaultUserManager: UserManager, InjectService {
    enum Error: Swift.Error {
        case alreadyRegistered
        case invalidCredentials
        case notFound
    }

    let repository: UserRepository

    public init(_ repository: UserRepository) {
        self.repository = repository
    }

    public func register(_ credentials: User.NewCredentials) throws -> User {
        guard try repository.find(email: credentials.email) == nil else {
            throw Error.alreadyRegistered
        }
        var user = User(credentials: credentials)
        user.id = try repository.add(user: user)
        return user
    }

    public func login(_ credentials: User.Credentials) throws -> User {
        guard let user = try repository.find(email: credentials.email) else {
            throw Error.notFound
        }
        guard user.password == credentials.password else {
            throw Error.invalidCredentials
        }
        return user
    }
}

extension User {
    public struct NewCredentials: Codable {
        let name: String
        let email: String
        let password: String
    }

    public struct Credentials: Decodable {
        let email: String
        let password: String
    }
}

extension User {
    init(credentials: NewCredentials) {
        self.init(
            name: credentials.name,
            email: credentials.email,
            password: credentials.password)
    }
}
