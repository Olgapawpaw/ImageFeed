import Foundation
import UIKit
import Kingfisher

public protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateUrlForAvatar()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    // MARK: - Public Properties
    weak var view: ProfileViewControllerProtocol?
    
    // MARK: - Private Properties
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    
    // MARK: - Public Methods
    func viewDidLoad() {
        updateUrlForAvatar()
        updateDataForProfile()
    }
    
    func updateUrlForAvatar() {
        guard
            let url = URL(string: profileImageService.avatarURL!)
        else {return}
        view?.updateAvatar(url: url)
    }
    
    func updateDataForProfile() {
        guard
            let loginNameLabel = profileService.profile?.loginName
        else {return}
        let nameLabel = profileService.profile?.name
        let bioLabel = profileService.profile?.bio
        view?.updateProfileData(nameLabel: nameLabel, loginNameLabel: loginNameLabel, bioLabel: bioLabel)
    }
}
