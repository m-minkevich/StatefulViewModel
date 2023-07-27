//
//  File.swift
//  
//
//  Created by Matt Minkevich on 05/07/2023.
//

import Foundation

/// Possible errors that can occur in the view model.
enum CustomError: Error {

    /// Indicates an invalid action
    case invalidAction

    /// Indicates bad memory dealloaction.
    case memoryLeak

    /// Indicates an invalid reducer.
    case invalidReducer
}
