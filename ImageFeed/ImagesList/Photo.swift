import Foundation

struct Photo {
    let id: String
    let width: Int
    let height: Int
    var size: CGSize {
        return CGSize(
            width: width,
            height: height
        )
    }
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
