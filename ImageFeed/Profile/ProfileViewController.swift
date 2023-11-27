import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        createProfileScreen()
    }
    
    // MARK: - Private Methods
    func createProfileScreen(){
        view.backgroundColor = UIColor(named: "YP Black")
        
        let profilePhotoImage = UIImage(named: "photo")
        let profilePhoto = UIImageView(image: profilePhotoImage)
        let nameLabel = UILabel()
        let idLabel = UILabel()
        let descriptionLabel = UILabel()
        let exitButton = UIButton.systemButton(
            with: UIImage(named: "exit")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        view.addSubview(profilePhoto)
        view.addSubview(nameLabel)
        view.addSubview(idLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        profilePhoto.backgroundColor = UIColor(named: "YP Black")
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        idLabel.textColor = UIColor(named: "YP Grey")
        idLabel.text = "@ekaterina_nov"
        idLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        exitButton.backgroundColor = UIColor(named: "YP Black")
        exitButton.tintColor = UIColor(named: "YP Red")
        
        NSLayoutConstraint.activate([
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70),
            profilePhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profilePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            idLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc
    private func didTapButton() {
    }
}
