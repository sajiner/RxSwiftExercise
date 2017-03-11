//
//  Service.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/30.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationService {

    /// 创建单例
    static let instance = ValidationService()
    
    /// 最小字符长度
    private let minCharactersCount = 6
    fileprivate let path = NSHomeDirectory() + "/Documents/users.plist"
    
    /// 用户名可用的Observable
    func validationUsername(_ username: String) -> Observable<Result> {
        if username.characters.count == 0 {
            return Observable.just(.empty)
        }
        if username.characters.count < minCharactersCount {
            return Observable.just(.fail(message: "用户长度至少为6个字符"))
        }
        if usernameValid(username) {
            return Observable.just(.fail(message: "用户名已存在"))
        }
        return Observable.just(.ok(message: "用户名可用"))
    }
    
    func validationPassword(_ password: String) -> Result {
        if password.characters.count == 0 {
            return .empty
        }
        if password.characters.count < minCharactersCount {
            return .fail(message: "密码至少为6个字符")
        }
        return .ok(message: "密码可用")
    }
    
    func validationRepeatPwd(_ password: String, _ repeatPwd: String) -> Result {
        if repeatPwd.characters.count == 0 {
            return .empty
        }
        if password == repeatPwd {
            return .ok(message: "密码可用")
        }
        return .fail(message: "两次密码不一样")
    }
    
    func register(_ username: String, password: String) -> Observable<Result> {
        let userDic = [username: password]
        if (userDic as NSDictionary).write(toFile: path, atomically: true) {
            return Observable.just(.ok(message: "注册成功"))
        }
        return Observable.just(.fail(message: "注册失败"))
    }
    
    func loginUsernameValid(_ username: String) -> Observable<Result> {
        if username.characters.count == 0 {
            return .just(.empty)
        }
        
        if usernameValid(username) {
            return .just(.ok(message: "用户名可用"))
        }
        return .just(.fail(message: "用户名不存在"))
    }
    
    func login(_ username: String, password: String) -> Observable<Result> {
        
        let userDic = NSDictionary(contentsOfFile: path)
        if let userPass = userDic?.object(forKey: username) as? String {
            if  userPass == password {
                return .just(.ok(message: "登录成功"))
            }
        }
        return .just(.fail(message: "密码错误"))
    }
    
}

extension ValidationService {
    
    /// 用户名是否存在的判断
    fileprivate func usernameValid(_ username: String) -> Bool {
        
        guard let userDict = NSDictionary(contentsOfFile: path) else { return false }
        let keysArray = userDict.allKeys as NSArray
        if keysArray.contains(username) {
            return true
        }
        return false
    }
}

extension Reactive where Base: UILabel {
    var validationResult: UIBindingObserver<Base, Result> {
        return UIBindingObserver(UIElement: base, binding: { (label, result) in
            label.text = result.description
            label.textColor = result.textColor
        })
    }
}

