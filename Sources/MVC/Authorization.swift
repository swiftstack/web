public enum Authorization {
    case any
    case user
    case guest
    case claim(String)
}

extension Authorization {
    public enum Result {
        case ok
        case unauthorized
        case unauthenticated
    }

    public func challenge(user: UserProtocol?) -> Result {
        guard let user = user else {
            switch self {
            case .any: return .ok
            case .guest: return .ok
            default: return .unauthenticated
            }
        }
        switch self {
        case .any: return .ok
        case .user: return .ok
        case .claim(let claim) where user.claims.contains(claim): return .ok
        default: return .unauthorized
        }
    }
}
