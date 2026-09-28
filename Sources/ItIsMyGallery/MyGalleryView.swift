import SwiftUI
import Photos

/// A drop-in SwiftUI view that shows the device's photo library in a scrollable
/// grid (3 or 4 columns) and opens a swipeable full-screen viewer on tap.
///
/// Usage:
/// ```swift
/// import MyGallery
///
/// struct ContentView: View {
///     var body: some View {
///         MyGalleryView(columns: 4)
///     }
/// }
/// ```
///
/// The host app must include `NSPhotoLibraryUsageDescription` in its Info.plist.
public struct MyGalleryView: View {
    @StateObject private var library = PhotoLibraryManager()
    @State private var selectedIndex: Int?

    private let columns: Int

    /// - Parameter columns: Number of columns in the grid. Supports 3 or 4 (defaults to 3).
    public init(columns: Int = 3) {
        self.columns = (columns == 4) ? 4 : 3
    }

    public var body: some View {
        Group {
            switch library.authorizationStatus {
            case .authorized, .limited:
                PhotoGridView(photos: library.photos, columns: columns) { index in
                    selectedIndex = index
                }
            case .denied, .restricted:
                PermissionDeniedView()
            case .notDetermined:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            @unknown default:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            library.requestAuthorizationAndFetch()
        }
        .fullScreenCover(isPresented: isDetailPresented) {
            if let selectedIndex {
                PhotoDetailView(photos: library.photos, startIndex: selectedIndex) {
                    self.selectedIndex = nil
                }
            }
        }
    }

    private var isDetailPresented: Binding<Bool> {
        Binding(
            get: { selectedIndex != nil },
            set: { isPresented in
                if !isPresented { selectedIndex = nil }
            }
        )
    }
}
