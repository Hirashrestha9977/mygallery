import Photos

/// A lightweight, identifiable wrapper around `PHAsset` used throughout MyGallery.
public struct PhotoAsset: Identifiable, Equatable, Hashable {
    public let id: String
    public let asset: PHAsset

    public init(asset: PHAsset) {
        self.id = asset.localIdentifier
        self.asset = asset
    }

    public static func == (lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
