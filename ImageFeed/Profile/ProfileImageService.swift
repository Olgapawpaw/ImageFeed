import Foundation

final class ProfileImageService {
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUsername: String?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()

    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        
        let request = URLRequest.makeHTTPRequestForProfile(httpMethod: "GET", token: token, pathURL: "/users/\(username)")
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let responseObject):
                self?.avatarURL = responseObject.profileImage.small
                completion(.success(responseObject.profileImage.small!))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self?.avatarURL as Any])
            case .failure(let error):
                completion(.failure(error))
                self?.lastUsername = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}

