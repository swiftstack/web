import Crypto
import struct Foundation.UUID

public protocol UserRepository {
    func get(id: String) throws -> User?
    func add(user: User) throws -> String
    func find(email: String) throws -> User?
}

public struct User: UserProtocol {
    public var id: String?
    public let name: String
    public let email: String
    public let password: Password
    public var claims: [String]

    public struct Password: Codable {
        let hash: String
        let salt: String

        init(plain password: String) {
            self.salt = UUID().uuidString
            self.hash = Password.calculateHash(for: password, with: salt)
        }

        static func ==(lhs: User.Password, rhs: String) -> Bool {
            return lhs.hash == calculateHash(for: rhs, with: lhs.salt)
        }

        static func calculateHash(
            for password: String,
            with salt: String
        ) -> String {
            var sha1 = SHA1()
            sha1.update([UInt8](password.utf8))
            sha1.update([UInt8](salt.utf8))
            return String(sha1.final())
        }
    }

    public init(
        name: String,
        email: String,
        password: String,
        claims: [String] = []
    ) {
        self.id = nil
        self.name = name
        self.email = email
        self.password = Password(plain: password)
        self.claims = claims
    }
}
