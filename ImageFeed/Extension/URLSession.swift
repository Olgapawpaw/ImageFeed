import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let responseObject = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(responseObject))
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
        return task
    }
}
