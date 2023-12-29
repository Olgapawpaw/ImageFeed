import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    // MARK: - IB Outlets
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    @IBAction func like(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        if isLiked {
             self.likeButton.imageView?.image = UIImage(named: "LikeActive")
         } else {
             self.likeButton.imageView?.image = UIImage(named: "LikeNoActive")
         }
    }
}

