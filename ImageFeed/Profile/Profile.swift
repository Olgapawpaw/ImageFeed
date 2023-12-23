import Foundation

struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
    var loginName: String {
        return "@\(self.username)"
    }
    let bio: String?
}



