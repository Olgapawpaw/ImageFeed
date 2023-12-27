@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testExample() throws {
        func testFetchPhotos() {
            let service = ImagesListService()
            
            let expectation = self.expectation(description: "Wait for Notification")
            NotificationCenter.default.addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main) { _ in
                    expectation.fulfill()
                }
            
            service.fetchPhotosNextPage() { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let photo):
                    print(photo)
                case .failure(let error):
                    print(error)
                    break
                }
            }
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
            
            service.fetchPhotosNextPage() { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let photo):
                    print(photo)
                case .failure(let error):
                    print(error)
                    break
                }
            }
            
            wait(for: [expectation], timeout: 10)
            
            XCTAssertEqual(service.photos.count, 10)
        }
    }
}

