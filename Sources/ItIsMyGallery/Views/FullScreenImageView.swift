import SwiftUI
import Photos

/// Loads and displays a single asset at (near) full resolution for the full-screen viewer.
struct FullScreenImageView: View {
    let asset: PHAsset

    @State private var image: UIImage?
    @State private var requestID: PHImageRequestID?

    private static let manager = PHImageManager.default()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                } else {
                    ProgressView()
                        .tint(.white)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear { loadFullImage() }
            .onDisappear { cancelLoad() }
        }
    }

    private func loadFullImage() {
        guard image == nil else { return }

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.isNetworkAccessAllowed = true

        requestID = Self.manager.requestImage(
            for: asset,
            targetSize: PHImageManagerMaximumSize,
            contentMode: .aspectFit,
            options: options
        ) { result, _ in
            if let result {
                self.image = result
            }
        }
    }

    private func cancelLoad() {
        if let requestID {
            Self.manager.cancelImageRequest(requestID)
        }
    }
}
