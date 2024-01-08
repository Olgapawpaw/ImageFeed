import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func UpdatePhotosAfterChangeLike (indexPath: IndexPath, cell: ImagesListCell)
    func FetchPhotosNextPage()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    // MARK: - Public Properties
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    // MARK: - Private Properties
    private var imagesListService = ImagesListService.shared
    
    // MARK: - Initializers
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Public Methods
    func UpdatePhotosAfterChangeLike(indexPath: IndexPath, cell: ImagesListCell) {
        photos = imagesListService.photos
        let photo = photos[indexPath.row]
        photos = imagesListService.photos
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async { [self] in
                switch result {
                case .success:
                    cell.setIsLiked(isLiked: !photo.isLiked)
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        let oldPhoto = photo
                        let newPhoto = Photo(
                            id: oldPhoto.id,
                            width: oldPhoto.width,
                            height: oldPhoto.height,
                            createdAt: oldPhoto.createdAt,
                            welcomeDescription: oldPhoto.welcomeDescription,
                            thumbImageURL: oldPhoto.thumbImageURL,
                            largeImageURL: oldPhoto.largeImageURL,
                            isLiked: !oldPhoto.isLiked
                        )
                        self.photos.remove(at: index)
                        self.photos.insert(newPhoto, at: index)
                    }
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    func FetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage(){ [weak self] result in
            guard let self else { return }
        }
    }
    
}
