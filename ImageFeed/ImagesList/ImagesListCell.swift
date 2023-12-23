import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - IB Outlets
    @IBOutlet private var photoImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Private Properties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Public Methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let currentPhotosName = photosName[indexPath.row]
        let likeActiveImage = UIImage(named: "LikeActive")
        
        guard let image = UIImage(named: currentPhotosName) else {
            return
        }
        
        cell.photoImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: NSDate() as Date)
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.imageView?.image = likeActiveImage
        }
    }
}

