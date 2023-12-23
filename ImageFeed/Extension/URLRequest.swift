import Foundation

extension URLRequest {
    static func makeHTTPRequestForProfile (httpMethod: String, token: String, pathURL: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = ApiConstants.schemeURL.rawValue
        urlComponents.host = ApiConstants.baseURL.rawValue
        urlComponents.path = pathURL
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
