# StatefulViewModel

The StatefulViewModel package provides a base class, `StatefulViewModel`, that helps manage the state and actions for a view in a unidirectional (alike Redux) way. It leverages Combine framework for reactive programming.

## Features

- Encapsulates the state and actions for a view in a single ViewModel class.
- Provides a reactive state publisher to notify observers of state changes.
- Supports dispatching actions to trigger state updates.
- Abstracts the handling of actions and state updates, allowing easy customization and extension.

## Requirements

- iOS 14.0+
- Swift 5.0+

## Installation

You can install the StatefulViewModel package using Swift Package Manager. Simply add the package as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/m-minkevich/StatefulViewModel.git", from: "1.0.3")
]
```

## Usage

To use the StatefulViewModel in your project, follow these steps:

1. Import the StatefulViewModel module into your file and subclass a view model class.
```swift
import StatefulViewModel

class MyViewModel: StatefulViewModel<MyState, MyAction> {
    // Add your custom properties and methods here
}

let initialState = MyState(/* Initial state properties */)
let viewModel = MyViewModel(currentState: initialState)
```
2. Override the reduce method in your custom view model to handle actions and return a publisher emitting new actions if needed.
```swift
override func reduce(action: MyAction) -> AnyPublisher<MyAction, Error> {
    // Implement your action handling logic here
}
```
3. Dispatch actions to trigger state updates using the dispatch method.
```swift
viewModel.dispatch(action: .myAction)
```
4. Access the (`@Published`) current state from the view.
```swift
let currentState = viewModel.currentState
```
## License

This project is licensed under the [MIT License](LICENSE).


