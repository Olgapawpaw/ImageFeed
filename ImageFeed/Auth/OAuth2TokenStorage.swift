import Foundation

class OAuth2TokenStorage {
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: "token") ?? "no"
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}

