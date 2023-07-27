//
// StatefulViewModel.swift
//
// StatefulViewModel Package
//

import Combine
import Foundation

open class StatefulViewModel<State: Equatable, Action: Equatable>: BaseStatefulViewModel {
    // MARK: Public Properties

    /// The published stream of view state updates.
    ///
    /// Observers can subscribe to this property to receive updates whenever the view state changes.
    ///
    /// Usage Example:
    /// ```
    /// viewModel.statePublisher
    ///     .sink { state in
    ///         // Handle the updated view state
    ///     }
    ///     .store(in: &cancellables)
    /// ```
    public var statePublisher: Published<State>.Publisher {
        $currentState
    }

    /// The current mutable view state.
    ///
    /// This property holds the current state of the view and triggers updates to the `state` property when modified.
    /// It is automatically published, allowing observers to subscribe and receive updates whenever the value changes.
    ///
    /// Usage Example:
    /// ```
    /// viewModel.currentState = newState
    /// ```
    ///
    /// - Note: This property is automatically published using the `@Published` property wrapper.
    ///
    /// For more information about subscribing to state updates, refer to the documentation of the `state` property.
    @Published public var currentState: State

    // MARK: Private Properties

    /// A subject that receives and emits actions.
    private let actionPublisher = PassthroughSubject<Action, Never>()

    /// A set of cancellables to manage the action subscriptions.
    private var actionCancellables = Set<AnyCancellable>()

    // MARK: Initializer

    /// Initializes the view model with the initial state.
    ///
    /// - Parameters:
    ///   - currentState: The initial state of the view model.
    public init(currentState: State) {
        self.currentState = currentState
        observeActions()
    }

    // MARK: Public Methods

    /// Sends an action to the view model, triggering state updates.
    ///
    /// - Parameter action: The action to be sent to the view model.
    ///
    /// Usage Example:
    /// ```
    /// viewModel.send(action: .fetchData)
    /// ```
    ///
    /// - Note: This method triggers the execution of the `handle(state:action:)` method in the view model,
    ///   allowing it to process the action and potentially update the view state.
    public func dispatch(action: Action) {
        actionPublisher.send(action)
    }

    /// Handles an action and returns a publisher emitting a new action if needed.
    ///
    /// Subclasses must override this method to define their specific action handling logic.
    ///
    /// - Parameters:
    ///   - action: The action to be handled.
    /// - Returns: A publisher emitting a new action if needed.
    open func reduce(action _: Action) -> AnyPublisher<Action, Error> {
        fatalError("handle(action:) must be overridden in the subclass")
    }
}

// MARK: Implementation Details

private extension StatefulViewModel {
    /// A publisher that combines the action subject and state to handle actions.
    var actionHandler: AnyPublisher<(State, Action), Error> {
        actionPublisher
            .flatMap { [weak self] action -> AnyPublisher<(State, Action), Error> in
                guard let self = self else {
                    return Fail(error: CustomError.memoryLeak).eraseToAnyPublisher()
                }

                let viewState = self.currentState
                return Just((viewState, action))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// Observes the actions and triggers the action handling logic.
    func observeActions() {
        actionHandler
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _, newAction in
                    guard let self = self else { return }

                    let cancellable = self.reduce(action: newAction)
                        .sink(receiveCompletion: { _ in }) { [weak self] newAction in
                            self?.actionPublisher.send(newAction)
                        }

                    self.actionCancellables.insert(cancellable)
                }
            )
            .store(in: &actionCancellables)
    }
}
