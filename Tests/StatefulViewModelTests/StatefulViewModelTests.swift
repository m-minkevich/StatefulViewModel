//
// StatefulViewModelTests.swift
//
// StatefulViewModel Package
//

@testable import StatefulViewModel
import Combine
import XCTest

final class StatefulViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testInitialState() {
        let initialState = "Initial State"
        let viewModel = MockStatefulViewModel<String, String>(currentState: initialState)

        XCTAssertEqual(viewModel.currentState, initialState, "Initial state should be set correctly")
    }

    func testReducer() {
        let viewModel = MockStatefulViewModel<String, String>(currentState: "")
        let testAction = "Test Action"
        let expectedNewState = "New State"

        viewModel.reduce(action: testAction)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { newAction in
                    XCTAssertEqual(newAction, expectedNewState, "Reducer should return the expected new state")
                }
            )
            .store(in: &viewModel.exposedActionCancellables)

        viewModel.dispatch(action: testAction)
    }

    func testStatePublisher() {
        let initialState = "Initial State"
            let viewModel = MockStatefulViewModel<String, String>(currentState: initialState)
            let newState = "New State"

            // Create an expectation for the state update
            let expectation = XCTestExpectation(description: "State update received")

            viewModel.statePublisher
                .sink { state in
                    // Update the state and fulfill the expectation
                    XCTAssertEqual(state, newState, "State publisher should emit updates when the state changes")
                    expectation.fulfill()
                }
                .store(in: &viewModel.exposedActionCancellables)

            viewModel.dispatch(action: "Test Action")

            wait(for: [expectation], timeout: 1.0)
    }
}
