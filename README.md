# StatefulViewModel

The StatefulViewModel package provides a base class, `StatefulViewModel`, that helps manage the state and actions for a view in a SwiftUI-based application. It follows the MVVM (Model-View-ViewModel) architectural pattern and leverages Combine framework for reactive programming.

## Features

- Encapsulates the state and actions for a view in a single ViewModel class.
- Provides a reactive state publisher to notify observers of state changes.
- Supports dispatching actions to trigger state updates.
- Abstracts the handling of actions and state updates, allowing easy customization and extension.

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.0+

## Installation

You can install the StatefulViewModel package using Swift Package Manager. Simply add the package as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/StatefulViewModel.git", from: "1.0.0")
]
```

## Usage

To use the StatefulViewModel in your project, follow these steps:

1. Import the StatefulViewModel module into your file:
```swift
import StatefulViewModel
```
