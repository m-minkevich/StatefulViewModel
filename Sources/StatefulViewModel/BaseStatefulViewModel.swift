import Combine
import Foundation

/// A base view model protocol that manages the state and actions for a view.
public protocol BaseStatefulViewModel: ObservableObject {

    /// The type representing the state of the view model.
    associatedtype State: Equatable

    /// The type representing the actions that can be dispatched to the view model.
    associatedtype Action: Equatable

    /// A publisher that emits state changes to observers.
    var statePublisher: Published<State>.Publisher { get }

    /// The current state of the view model.
    var currentState: State { get set }

    /// Dispatches an action to the view model for processing.
    ///
    /// - Parameter action: The action to be dispatched.
    func dispatch(action: Action)
}
