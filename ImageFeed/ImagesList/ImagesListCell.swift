import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    // MARK: - IB Outlets
    @IBOutlet var photoImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Public Properties
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IB Actions
    @IBAction func like(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Public Methods
    func setIsLiked(isLiked: Bool) {
        if isLiked {
            self.likeButton.imageView?.image = UIImage(named: "LikeActive")
        } else {
            self.likeButton.imageView?.image = UIImage(named: "LikeNoActive")
        }
    }
}

