import Foundation
import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createSplashView()
        
        if OAuth2TokenStorage().token != nil {
            fetchProfile()
        } else {
            guard let authViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
             else { fatalError("Invalid action") }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func ShowErrorAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        fetchOAuthToken(code)
        UIBlockingProgressHUD.show()
    }
        
        private func fetchOAuthToken(_ code: String) {
            OAuth2Service().fetchOAuthToken(code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let bearerToken):
                    OAuth2TokenStorage().token = bearerToken
                    self.fetchProfile()
                case .failure:
                    ShowErrorAlert()
                    break
                }
            }
        }
    
    private func fetchProfile() {
        guard let token = OAuth2TokenStorage().token else { return }
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success (let result):
                profileImageService.fetchProfileImageURL(username: result.username) { _ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                ShowErrorAlert()
                break
            }
        }
    }
    
    private func createSplashView() {
        view.backgroundColor = UIColor(named: "YP Black")
        let splashScreenLogo = UIImageView()
        splashScreenLogo.backgroundColor = UIColor(named: "YP Black")
        splashScreenLogo.contentMode = .scaleToFill
        splashScreenLogo.image = UIImage(named: "Vector")
        view.addSubview(splashScreenLogo)
        splashScreenLogo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashScreenLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
