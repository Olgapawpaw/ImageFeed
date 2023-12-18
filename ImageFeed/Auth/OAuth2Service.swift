import Foundation

final class OAuth2Service {
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void ) {
        let request = URLRequest.makeHTTPRequest(httpMethod: "POST", code: code)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let responseObject = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                            completion(.success(responseObject.accessToken))
                        } catch let jsonErorr {
                            completion(.failure(NetworkError.jsonErorr(jsonErorr)))
                        }
                            } else {
                                completion(.failure(NetworkError.httpStatusCode(statusCode)))
                            }
                        } else if let error = error {
                            completion(.failure(NetworkError.urlRequestError(error)))
                        } else {
                            completion(.failure(NetworkError.urlSessionError))
                        }
            }
        }
        task.resume()
    }
}

extension URLRequest {
    static func makeHTTPRequest (httpMethod: String, code: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = SchemeURL
        urlComponents.host = HostURL
        urlComponents.path = PathURL
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case jsonErorr(Error)
}

