import Photos
import SwiftUI

/// Requests photo library access and exposes the user's photo assets.
///
/// Host apps can use `MyGalleryView` directly (which owns its own manager),
/// or instantiate `PhotoLibraryManager` themselves to build a custom UI.
@MainActor
public final class PhotoLibraryManager: ObservableObject {
    @Published public private(set) var photos: [PhotoAsset] = []
    @Published public private(set) var authorizationStatus: PHAuthorizationStatus

    public init() {
        self.authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }

    /// Requests read/write photo library authorization and fetches photos on success.
    public func requestAuthorizationAndFetch() {
        let current = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if current == .authorized || current == .limited {
            authorizationStatus = current
            fetchPhotos()
            return
        }

        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            Task { @MainActor in
                self?.authorizationStatus = status
                if status == .authorized || status == .limited {
                    self?.fetchPhotos()
                }
            }
        }
    }

    /// Fetches all image assets from the photo library, newest first.
    public func fetchPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)

        var assets: [PhotoAsset] = []
        assets.reserveCapacity(result.count)
        result.enumerateObjects { asset, _, _ in
            assets.append(PhotoAsset(asset: asset))
        }
        self.photos = assets
    }
}
