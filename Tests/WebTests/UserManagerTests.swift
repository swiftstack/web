import Test
import MVC
import Foundation
@testable import HTTP
@testable import Web

class UserManagerTests: TestCase {
    public final class InMemoryUserRepository: UserRepository {
        var users: [User]

        public init() {
            self.users = []
        }

        public func get(id: String) throws -> User? {
            return users.first(where: { $0.id == id })
        }

        public func add(user: User) throws -> String {
            var user = user
            let id = UUID().uuidString
            user.id = id
            users.append(user)
            return id
        }

        public func find(email: String) throws -> User? {
            return users.first(where: { $0.email == email })
        }
    }

    func testRegister() {
        scope {
            let users = DefaultUserManager(InMemoryUserRepository())

            let user = try users.register(User.NewCredentials(
                name: "user", email: "new@user.com", password: "123"))

            assertEqual(user.name, "user")
            assertEqual(user.email, "new@user.com")
            assertTrue(user.password == "123")
            assertTrue(user.password.hash != "123")

            assertThrowsError(try users.register(User.NewCredentials(
                name: "user", email: "new@user.com", password: "123")))
            { error in
                assertEqual(error as? DefaultUserManager.Error, .alreadyRegistered)
            }
        }
    }

    func testLogin() {
        scope {
            let users = DefaultUserManager(InMemoryUserRepository())

            _ = try users.register(User.NewCredentials(
                name: "user", email: "new@user.com", password: "123"))

            let user = try users.login(User.Credentials(
                email: "new@user.com", password: "123"))

            assertEqual(user.name, "user")
            assertEqual(user.email, "new@user.com")
            assertTrue(user.password == "123")
            assertTrue(user.password.hash != "123")

            assertThrowsError(try users.login(User.Credentials(
                email: "unknown@user.com", password: "123")))
            { error in
                assertEqual(error as? DefaultUserManager.Error, .notFound)
            }

            assertThrowsError(try users.login(User.Credentials(
                email: "new@user.com", password: "000")))
            { error in
                assertEqual(error as? DefaultUserManager.Error, .invalidCredentials)
            }
        }
    }
}
