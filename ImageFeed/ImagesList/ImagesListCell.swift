//
//  File.swift
//  ImageFeed
//
//  Created by Kuimova Olga on 04.11.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var imagePhoto: UIImageView!
    @IBOutlet var buttonLike: UIButton!
    @IBOutlet var labelDate: UILabel!
    
}
