import Foundation

final class OAuth2TokenStorage {
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "token") ?? nil
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}

