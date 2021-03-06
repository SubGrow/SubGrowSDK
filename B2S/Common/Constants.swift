//
//  Constants.swift
//  B2S
//
//  Created by Egor Sakhabaev on 05.07.2021.
//

import Foundation

enum InternalError: LocalizedError {    
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Something went wrong. Try again later"
        }
    }
}
