import Test
import MVC
import UUID
@testable import HTTP
@testable import Web

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

test("Register") {
    let users = DefaultUserManager(InMemoryUserRepository())

    let user = try users.register(User.NewCredentials(
        name: "user", email: "new@user.com", password: "123"))

    expect(user.name == "user")
    expect(user.email == "new@user.com")
    expect(user.password == "123")
    expect(user.password.hash != "123")

    expect(throws: DefaultUserManager.Error.alreadyRegistered) {
        try users.register(User.NewCredentials(
            name: "user",
            email: "new@user.com",
            password: "123"))
    }
}

test("Login") {
    let users = DefaultUserManager(InMemoryUserRepository())

    _ = try users.register(User.NewCredentials(
        name: "user", email: "new@user.com", password: "123"))

    let user = try users.login(User.Credentials(
        email: "new@user.com", password: "123"))

    expect(user.name == "user")
    expect(user.email == "new@user.com")
    expect(user.password == "123")
    expect(user.password.hash != "123")

    expect(throws: DefaultUserManager.Error.notFound) {
        try users.login(User.Credentials(
            email: "unknown@user.com",
            password: "123"))
    }

    expect(throws: DefaultUserManager.Error.invalidCredentials) {
        try users.login(User.Credentials(
            email: "new@user.com",
            password: "000"))
    }
}

await run()
