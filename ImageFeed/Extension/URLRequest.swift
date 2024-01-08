import Foundation

extension URLRequest {
    static func makeHTTPRequest (httpMethod: String, token: String, pathURL: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = AuthConfiguration.standard.schemeURL
        urlComponents.host = AuthConfiguration.standard.baseURL
        urlComponents.path = pathURL
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
