//
//  Protocol.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/30.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

enum Result {
    case empty
    case ok(message: String)
    case fail(message: String)
}

extension Result {
    var textColor: UIColor {
        switch self {
        case .ok:
            return UIColor.green
        case .fail:
            return UIColor.red
        case .empty:
            return UIColor.black
        }
    }
    
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .fail(message):
            return message
        }
    }
    
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}
