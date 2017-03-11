//
//  RegisterViewController.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/30.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatTextField: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    fileprivate lazy var registerVM: RegisterViewModel = RegisterViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// input
        usernameTextField.rx.text.orEmpty
            .bindTo(registerVM.username)
            .addDisposableTo(bag)
        passwordTextField.rx.text.orEmpty
            .bindTo(registerVM.password)
            .addDisposableTo(bag)
        repeatTextField.rx.text.orEmpty
            .bindTo(registerVM.repeatPwd)
            .addDisposableTo(bag)
        registerButton.rx.tap
            .bindTo(registerVM.registerTap)
            .addDisposableTo(bag)
        
        /// output
        registerVM.usernameUsable
            .bindTo(usernameLabel.rx.validationResult)
            .addDisposableTo(bag)
        registerVM.passwordUsable
            .bindTo(passwordLabel.rx.validationResult)
            .addDisposableTo(bag)
        registerVM.repeatPwdUsable
            .bindTo(repeatLabel.rx.validationResult)
            .addDisposableTo(bag)
        registerVM.registerBtnEnable.subscribe(onNext: { (enable) in
            self.registerButton.isEnabled = enable
            self.registerButton.alpha = enable ? 1.0 : 0.5
        }).addDisposableTo(bag)
        registerVM.registerResult.subscribe(onNext: { (result) in
            switch result {
            case .ok:
                _ = self.navigationController?.popViewController(animated: true)
            case .empty:
                self.showAlert(message: "")
            case let .fail(message):
                self.showAlert(message: message)
            }
        }).addDisposableTo(bag)

    }
}

extension RegisterViewController {
    fileprivate func showAlert(message: String) {
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}








