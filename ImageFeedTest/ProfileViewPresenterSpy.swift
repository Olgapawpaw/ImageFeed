import Foundation
import ImageFeed

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var updateUrl: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateUrlForAvatar() {
        updateUrl = true
    }
}
