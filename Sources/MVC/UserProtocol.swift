public protocol UserProtocol: Codable {
    var name: String { get }
    var claims: [String] { get }
}

public extension UserProtocol {
    var claims: [String] {
        return []
    }
}
