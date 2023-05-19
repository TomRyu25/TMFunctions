import XCTest
@testable import TMFunctions

final class TMFunctionsTests: XCTestCase {
    func testShowToast() {
        // Create a mock view
        let mockView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        
        // Call the showToast function
        TMFunctions.showToast(on: mockView, message: "Test Message")
        
        // Verify that the toast label is added to the view
        XCTAssertEqual(mockView.subviews.count, 1)
        XCTAssertTrue(mockView.subviews[0] is UILabel)
        
        // Verify the properties of the toast label
        let toastLabel = mockView.subviews[0] as! UILabel
        XCTAssertEqual(toastLabel.text, "Test Message")
        // Add more assertions to verify other properties if needed
    }
    
    func testPresentImage() {
        class MockViewController: UIViewController {
            var presentedVC: UIViewController?
            
            override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
                presentedVC = viewControllerToPresent
                super.present(viewControllerToPresent, animated: flag, completion: completion)
            }
        }
        
        // Create a mock view controller
        let mockViewController = MockViewController()
        
        // Create a test image
        let testImage = UIImage(systemName: "photo.fill")

        // Unwrap the optional testImage
        guard let unwrappedTestImage = testImage else {
            XCTFail("Failed to load test image")
            return
        }
        
        // Call the presentImage function
        TMFunctions.presentImage(from: mockViewController, tappedImage: unwrappedTestImage)
        
        // Verify that the PreviewImageVC is presented
        XCTAssertNotNil(mockViewController.presentedVC)
        XCTAssertTrue(mockViewController.presentedVC is PreviewImageVC)
        
        // Verify the properties of the presented PreviewImageVC
        let presentedVC = mockViewController.presentedVC as! PreviewImageVC
        XCTAssertEqual(presentedVC.modalPresentationStyle, .overCurrentContext)
        XCTAssertEqual(presentedVC.image, testImage)
        // Add more assertions to verify other properties if needed
    }
}
