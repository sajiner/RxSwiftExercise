//
//  RegisterViewModel.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/30.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewModel {

    // input
    let username = Variable<String>("")
    let password = Variable<String>("")
    let repeatPwd = Variable<String>("")
    let registerTap = PublishSubject<Void>()
    
    // output
    let usernameUsable: Observable<Result>
    let passwordUsable: Observable<Result>
    let repeatPwdUsable: Observable<Result>
    let registerBtnEnable: Observable<Bool>
    let registerResult: Observable<Result>
    
    
    init() {
        let service = ValidationService.instance
        
        usernameUsable = username.asObservable().flatMapLatest({ (username) in
            return service.validationUsername(username)
                .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(.fail(message: "username检测出错"))
        }).shareReplay(1)
        
        passwordUsable = password.asObservable().map({ (password) in
            return service.validationPassword(password)
        }).shareReplay(1)
        
        repeatPwdUsable = Observable.combineLatest(password.asObservable(), repeatPwd.asObservable(), resultSelector: {
            return service.validationRepeatPwd($0, $1)
        }).shareReplay(1)
        
        registerBtnEnable = Observable.combineLatest(usernameUsable, passwordUsable, repeatPwdUsable, resultSelector: {(usernameUsable, passwordUsable, repeatPwdUsable) in
            return usernameUsable.isValid && passwordUsable.isValid && repeatPwdUsable.isValid
            })
            .distinctUntilChanged()
            .shareReplay(1)
        let usernameAndPassword = Observable.combineLatest(username.asObservable(), password.asObservable(), resultSelector: {
            ($0, $1)
        })
        registerResult = registerTap.asObservable().withLatestFrom(usernameAndPassword)
            .flatMapLatest({ (username, password) in
                return service.register(username, password: password)
                    .observeOn(MainScheduler.instance)
                    .catchErrorJustReturn(.fail(message: "注册出错"))
            }).shareReplay(1)
    }
}
