//
//  MockStatefulViewModel.swift
//  
//
//  Created by Matt Minkevich on 24/07/2023.
//

import Combine
import Foundation
@testable import StatefulViewModel

class MockStatefulViewModel<State: Equatable, Action: Equatable>: StatefulViewModel<State, Action> {

    var exposedActionCancellables = Set<AnyCancellable>()

    var actionReducer: ((Action) -> AnyPublisher<Action, Error>)?

    override func reduce(action: Action) -> AnyPublisher<Action, Error> {
        actionReducer?(action) ?? Fail(error: CustomError.invalidReducer).eraseToAnyPublisher()
    }
}
