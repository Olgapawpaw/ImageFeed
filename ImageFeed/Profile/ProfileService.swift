import Foundation

final class ProfileService {
    // MARK: - Public Properties
    static let shared = ProfileService()
    
    // MARK: - Private Properties
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    // MARK: - Public Methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = URLRequest.makeHTTPRequest(httpMethod: "GET", token: token, pathURL: "/me")
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let responseObject):
                let profile = Profile(username: responseObject.username, firstName: responseObject.firstName, lastName: responseObject.lastName, bio: responseObject.bio)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
                self?.lastToken = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}

