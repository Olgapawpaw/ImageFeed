import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage().token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "ShowAuthenticationScreenSegueIdentifier", sender: nil)
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
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAuthenticationScreenSegueIdentifier" {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for ShowAuthenticationScreenSegueIdentifier")
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
           }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.show()
        self.fetchOAuthToken(code)
    }
        
        private func fetchOAuthToken(_ code: String) {
            OAuth2Service().fetchOAuthToken(code) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let bearerToken):
                    OAuth2TokenStorage().token = bearerToken
                    self.switchToTabBarController()
                    ProgressHUD.dismiss()
                case .failure:
                    ProgressHUD.dismiss()
                    // TODO [Sprint 11]
                    break
                }
            }
        }
}
