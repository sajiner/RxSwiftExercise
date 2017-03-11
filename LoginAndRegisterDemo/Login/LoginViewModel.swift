//
//  LoginViewModel.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/30.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    
    let usernameUsable: Driver<Result>
    let loginBtnEnabled: Driver<Bool>
    let loginResult: Driver<Result>

    init(input: (username: Driver<String>, password: Driver<String>, loginTaps: Driver<Void>), service: ValidationService) {
        usernameUsable = input.username
            .flatMapLatest({ (username) in
                return service.loginUsernameValid(username)
                    .asDriver(onErrorJustReturn: .fail(message: "连接server失败"))
        })
        
        loginBtnEnabled = input.password
            .map({$0.characters.count > 0 })
            .asDriver()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            ($0, $1)
        }
        loginResult = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest{ (username, password) in
                return service.login(username, password: password)
                    .asDriver(onErrorJustReturn: .fail(message: "连接server失败"))
        }
    }
}
