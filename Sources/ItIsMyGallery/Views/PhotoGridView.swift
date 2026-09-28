import SwiftUI

/// A vertically scrolling grid of photo thumbnails, 3 or 4 columns wide.
struct PhotoGridView: View {
    let photos: [PhotoAsset]
    let columns: Int
    let onTap: (Int) -> Void

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 2), count: columns)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 2) {
                ForEach(Array(photos.enumerated()), id: \.element.id) { index, photo in
                    PhotoThumbnailView(asset: photo.asset)
                        .contentShape(Rectangle())
                        .onTapGesture { onTap(index) }
                }
            }
        }
    }
}
