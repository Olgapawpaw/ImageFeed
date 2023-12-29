import Foundation

struct isLikedResult: Decodable {
    let photo: photo
    
    enum CodingKeys: String, CodingKey {
        case photo
    }
    
    struct photo: Codable {
        let isLiked: Bool
        
        enum CodingKeys: String, CodingKey {
            case isLiked = "liked_by_user"
        }
    }
}

