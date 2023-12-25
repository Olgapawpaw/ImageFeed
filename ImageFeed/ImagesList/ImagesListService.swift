import Foundation

final class ImagesListService {
    private var lastLoadedPage: Int? = nil
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var nextPage = 1
    private let dateFormatter = ISO8601DateFormatter()
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = OAuth2TokenStorage().token else { return }
        
        if task == nil {
            let request = URLRequest.makeHTTPRequestForImageList(httpMethod: "GET", token: token, pathURL: "/photos", page: nextPage)
            
            let session = URLSession.shared
            let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                switch result {
                case .success(let responseObjects):
                    let photo = responseObjects.map { responseObject in
                        return Photo(id: responseObject.id, width: responseObject.width, height: responseObject.height, createdAt: self?.dateFormatter.date(from: responseObject.createdAt), welcomeDescription: responseObject.welcomeDescription, thumbImageURL: responseObject.ImageURL.thumb, largeImageURL: responseObject.ImageURL.full, isLiked: responseObject.isLiked)
                    }
                    completion(.success(photo))
                    DispatchQueue.main.async { [weak self] in
                                            guard let self = self else { return }
                                            self.photos.append(contentsOf: photo)
                                            NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: nil)
                                            self.nextPage += 1
                                            self.lastLoadedPage = self.nextPage - 1
                                        }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            self.task = task
            task.resume()
        }
    }
}
