import Foundation

final class ImagesListService {
    private var lastLoadedPage: Int? = nil
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var nextPage = 1
    private let dateFormatter = ISO8601DateFormatter()
    static let shared = ImagesListService()
    
    private init() { }
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        if self.task == nil {
            let request = URLRequest.makeHTTPRequestForImageList(httpMethod: "GET", token: token, pathURL: "/photos", page: nextPage)
            
            let session = URLSession.shared
            let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                switch result {
                case .success(let responseObjects):
                    let photo = responseObjects.map { responseObject in
                        return Photo(
                            id: responseObject.id,
                            width: responseObject.width,
                            height: responseObject.height,
                            createdAt: self?.dateFormatter.date(from: responseObject.createdAt),
                            welcomeDescription: responseObject.welcomeDescription,
                            thumbImageURL: responseObject.imageURL.thumb,
                            largeImageURL: responseObject.imageURL.full,
                            isLiked: responseObject.isLiked
                        )
                    }
                    completion(.success(photo))
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.photos.append(contentsOf: photo)
                        NotificationCenter.default
                            .post(
                                name: ImagesListService.DidChangeNotification,
                                object: self,
                                userInfo: ["photos": self.photos as Any])
                        self.nextPage += 1
                        self.lastLoadedPage = self.nextPage - 1
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
            self.task = nil
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        let request = URLRequest.makeHTTPRequest(httpMethod: isLike ? "POST" : "DELETE", token: token, pathURL: "/photos/\(photoId)/like")
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<isLikedResult, Error>) in
            switch result {
            case .success(let responseObject):
                completion(.success(()))
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let oldPhoto = photos[index]
                        let newPhoto = Photo(
                            id: oldPhoto.id,
                            width: oldPhoto.width,
                            height: oldPhoto.height,
                            createdAt: oldPhoto.createdAt,
                            welcomeDescription: oldPhoto.welcomeDescription,
                            thumbImageURL: oldPhoto.thumbImageURL,
                            largeImageURL: oldPhoto.largeImageURL,
                            isLiked: responseObject.photo.isLiked
                        )
                        photos.remove(at: index)
                        photos.insert(newPhoto, at: index)
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
        self.task = nil
    }
}
    
    
    
//    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
//
//        guard let token = OAuth2TokenStorage().token else { return }
//
//        let request = URLRequest.makeHTTPRequest(httpMethod: isLike ? "POST" : "DELETE", token: token, pathURL: "/photos/\(photoId)/like")
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (data, response, error) in
//            DispatchQueue.main.async {
//                if let response = response,
//                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                    if 200 ..< 300 ~= statusCode {
//                        completion(.success(()))
//                    } else {
//                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
//                    }
//                } else if let error = error {
//                    completion(.failure(NetworkError.urlRequestError(error)))
//                } else {
//                    completion(.failure(NetworkError.urlSessionError))
//                }
//            }
//        }
//        task.resume()
//    }
