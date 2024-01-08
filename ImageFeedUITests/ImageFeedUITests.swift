import XCTest
@testable import ImageFeed

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        sleep(2)
        app.buttons["Authenticate"].tap()

        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        sleep(2)
        loginTextField.typeText("olga.kuimova.97@mail.ru")
        webView.swipeUp()
        app.toolbars.buttons["Done"].tap()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        sleep(2)
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("Welcome12!!!")
        webView.swipeUp()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        sleep(4)
        let tablesQuery = app.tables
        sleep(4)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()

        sleep(4)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)

        cellToLike.buttons["LikeButton"].tap()
        sleep(2)
        cellToLike.buttons["LikeButton"].tap()
        sleep(2)

        sleep(4)

        cell.tap()

        sleep(4)

        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)
        XCTAssertTrue(app.staticTexts["Olga Kuimova"].exists)
        XCTAssertTrue(app.staticTexts["@olgapewpaw"].exists)

        app.buttons["LogoutButton"].tap()

        app.alerts["Пока, Пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
    }
}
