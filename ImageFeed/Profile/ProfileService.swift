import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = URLRequest.makeHTTPRequestForProfile(httpMethod: "GET", token: token)
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let responseObject):
                self?.profile = (Profile(username: responseObject.username, firstName: responseObject.firstName, lastName: responseObject.lastName, bio: responseObject.bio))
                completion(.success(Profile(username: responseObject.username, firstName: responseObject.firstName, lastName: responseObject.lastName, bio: responseObject.bio)))
            case .failure(let error):
                completion(.failure(error))
                self?.lastToken = nil
            }
        }

        self.task = task
        task.resume()
    }
}

extension URLRequest {
    static func makeHTTPRequestForProfile (httpMethod: String, token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = ApiConstants.schemeURL.rawValue
        urlComponents.host = ApiConstants.baseURL.rawValue
        urlComponents.path = NetworkURL.pathURL.rawValue
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

private enum NetworkURL: String {
    case pathURL = "/me"
}

