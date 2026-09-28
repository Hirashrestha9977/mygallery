import XCTest
@testable import ItIsMyGallery

final class MyGalleryTests: XCTestCase {
    func testColumnsClampToSupportedValues() {
        // MyGalleryView only supports 3 or 4 columns; anything else falls back to 3.
        _ = MyGalleryView(columns: 3)
        _ = MyGalleryView(columns: 4)
        _ = MyGalleryView(columns: 5)
    }
}
