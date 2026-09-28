# MyGallery

A Swift Package that provides a drop-in SwiftUI photo gallery: a scrollable grid of the
device's photo library plus a full-screen, swipeable viewer.

## Features

- Fetches photos from the user's photo library via PhotoKit
- Vertically scrolling grid, 3 or 4 columns per row
- Tap a thumbnail to open it full screen
- Swipe left/right (drag gesture) to move to the next/previous photo, with a spring animation
- Handles photo library permission states (not determined, authorized, limited, denied)

## Installation

Add the package in Xcode via **File > Add Package Dependencies…** and point it at this
repository/local path, or add it to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../mygallery")
]
```

## Required setup (host app)

Swift packages cannot ship an `Info.plist` permission string, so add this key to your
**app's** Info.plist:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We use your photo library to show your gallery.</string>
```

## Usage

```swift
import SwiftUI
import MyGallery

struct ContentView: View {
    var body: some View {
        MyGalleryView(columns: 4) // 3 or 4 columns; defaults to 3
    }
}
```

`MyGalleryView` handles permission requests, grid layout, and the full-screen viewer
internally — no other setup is required.

### Advanced: custom UI

`PhotoLibraryManager` and `PhotoAsset` are also public, so you can build your own grid
or viewer on top of PhotoKit data if `MyGalleryView` doesn't fit your layout:

```swift
@StateObject var library = PhotoLibraryManager()

// library.requestAuthorizationAndFetch()
// library.photos // [PhotoAsset]
```

## Requirements

- iOS 15+
- Swift 5.9+
