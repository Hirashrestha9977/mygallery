import SwiftUI
import Photos

/// A single grid cell that lazily loads a square thumbnail for a `PHAsset`.
struct PhotoThumbnailView: View {
    let asset: PHAsset

    @State private var image: UIImage?
    @State private var requestID: PHImageRequestID?

    private static let manager: PHCachingImageManager = PHCachingImageManager()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.15)
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
            .clipped()
            .onAppear { loadThumbnail(cellWidth: geometry.size.width) }
            .onDisappear { cancelLoad() }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func loadThumbnail(cellWidth: CGFloat) {
        guard image == nil else { return }

        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: cellWidth * scale, height: cellWidth * scale)

        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        requestID = Self.manager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
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
