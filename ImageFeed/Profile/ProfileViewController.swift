import Foundation
import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateProfileData(nameLabel: String?, loginNameLabel: String, bioLabel: String?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: - Public Properties
    var presenter: ProfileViewPresenterProtocol?
    
    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profilePhoto = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let bioLabel = UILabel()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileScreen()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                presenter?.updateUrlForAvatar()
            }
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Public Methods
    func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profilePhoto.kf.indicatorType = .activity
        profilePhoto.kf.setImage(with: url,
                                 options: [.processor(processor)])
    }
    
    func updateProfileData(nameLabel: String?, loginNameLabel: String, bioLabel: String?) {
        self.nameLabel.text = nameLabel
        self.loginNameLabel.text = loginNameLabel
        self.bioLabel.text = bioLabel
    }
    
    // MARK: - Private Methods
    private func createProfileScreen(){
        view.backgroundColor = UIColor(named: "YP Black")
        let exitButton = UIButton.systemButton(
            with: UIImage(named: "exit")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        exitButton.accessibilityIdentifier = "LogoutButton"
        
        view.addSubview(profilePhoto)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(bioLabel)
        view.addSubview(exitButton)
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        profilePhoto.backgroundColor = UIColor(named: "YP Black")
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = 35
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        loginNameLabel.textColor = UIColor(named: "YP Grey")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        bioLabel.textColor = .white
        bioLabel.font = UIFont.systemFont(ofSize: 13)
        exitButton.backgroundColor = UIColor(named: "YP Black")
        exitButton.tintColor = UIColor(named: "YP Red")
        
        NSLayoutConstraint.activate([
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            profilePhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profilePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func didTapButton() {
        let alert = UIAlertController(title: "Пока, Пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let doingAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else {return}
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach { record in
                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                }
            }
            OAuth2TokenStorage().deleteToken()
            let window = UIApplication.shared.windows.first
            window?.rootViewController = SplashViewController()
        }
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        alert.addAction(doingAction)
        present(alert, animated: true, completion: nil)
    }
}
