import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    // MARK: - Public Properties
    static let ShowWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AuthViewController.ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(AuthViewController.ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service().fetchOAuthToken(code) { result in
            switch result {
            case .success(let bearerToken):
                if OAuth2TokenStorage().token == bearerToken {
                } else {
                    OAuth2TokenStorage().token = bearerToken
                }
            case .failure(let error):
                print(error)
            }
        }
        
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

