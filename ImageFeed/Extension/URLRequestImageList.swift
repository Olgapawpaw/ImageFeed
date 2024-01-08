import Foundation

extension URLRequest {
    static func makeHTTPRequestForImageList (httpMethod: String, token: String, pathURL: String, page: Int) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = AuthConfiguration.standard.schemeURL
        urlComponents.host = AuthConfiguration.standard.baseURL
        urlComponents.path = pathURL
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page))
        ]
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
