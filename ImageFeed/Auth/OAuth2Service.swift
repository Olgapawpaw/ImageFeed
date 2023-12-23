import Foundation

final class OAuth2Service {
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()                                      
        lastCode = code
        let request = URLRequest.makeHTTPRequest(httpMethod: "POST", code: code)
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let responseObject):
                completion(.success(responseObject.accessToken))
            case .failure(let error):
                completion(.failure(error))
                self?.lastCode = nil
            }
        }
        
        self.task = task
        task.resume()
    }
}

extension URLRequest {
    static func makeHTTPRequest (httpMethod: String, code: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = ApiConstants.schemeURL.rawValue
        urlComponents.host = ApiConstants.hostURL.rawValue
        urlComponents.path = NetworkURL.pathURL.rawValue
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ApiConstants.accessKey.rawValue),
            URLQueryItem(name: "client_secret", value: ApiConstants.secretKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: ApiConstants.redirectURI.rawValue),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

private enum NetworkURL: String {
    case pathURL = "/oauth/token"
}

