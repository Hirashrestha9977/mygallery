import SwiftUI
import Photos

/// Full-screen photo viewer. A horizontal drag gesture pages between the previous,
/// current, and next photo with a spring animation, mimicking the system Photos app.
struct PhotoDetailView: View {
    let photos: [PhotoAsset]
    let onDismiss: () -> Void

    @State private var currentIndex: Int
    @State private var dragTranslation: CGFloat = 0
    @GestureState private var isDragging = false

    init(photos: [PhotoAsset], startIndex: Int, onDismiss: @escaping () -> Void) {
        self.photos = photos
        self.onDismiss = onDismiss
        self._currentIndex = State(initialValue: startIndex)
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()

                ZStack {
                    ForEach(neighborIndices, id: \.self) { index in
                        FullScreenImageView(asset: photos[index].asset)
                            .frame(width: width, height: geometry.size.height)
                            .offset(x: CGFloat(index - currentIndex) * width + dragTranslation)
                    }
                }
                .gesture(dragGesture(width: width))
                .animation(isDragging ? nil : .spring(response: 0.35, dampingFraction: 0.85), value: dragTranslation)
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: currentIndex)

                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white, .black.opacity(0.4))
                }
                .padding()
            }
        }
        .statusBarHidden()
        .background(Color.black.ignoresSafeArea())
    }

    /// Only the previous, current, and next indices are rendered for smooth, cheap paging.
    private var neighborIndices: [Int] {
        [currentIndex - 1, currentIndex, currentIndex + 1].filter { photos.indices.contains($0) }
    }

    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture()
            .updating($isDragging) { _, state, _ in state = true }
            .onChanged { value in
                dragTranslation = value.translation.width
            }
            .onEnded { value in
                let threshold = width * 0.25
                var newIndex = currentIndex

                if value.translation.width < -threshold, currentIndex < photos.count - 1 {
                    newIndex += 1
                } else if value.translation.width > threshold, currentIndex > 0 {
                    newIndex -= 1
                }

                currentIndex = newIndex
                dragTranslation = 0
            }
    }
}
