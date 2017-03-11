//
//  ViewController.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/28.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    struct Player {
        var score: Variable<Int>
    }
    
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let sourceSequence = PublishSubject<String>()
        let referenceSequence = PublishSubject<String>()
        
        sourceSequence
            .skipUntil(referenceSequence)
            .subscribe(onNext: { print($0) })
            .addDisposableTo(bag)
        
        sourceSequence.onNext("🐱")
        sourceSequence.onNext("🐰")
        sourceSequence.onNext("🐶")
        
        referenceSequence.onNext("🔴")
        
        sourceSequence.onNext("🐸")
        sourceSequence.onNext("🐷")
        sourceSequence.onNext("🐵")
        
    }
    
    func demo() {
        let jim = Player(score: Variable(80))
        let lili = Player(score: Variable(90))
        let tom = Player(score: Variable(88))
        
        let player = Variable(jim)
        player.asObservable().flatMapLatest({$0.score.asObservable()})
            .subscribe(onNext: { print($0) }).addDisposableTo(bag)
        
        jim.score.value = 99
        player.value = lili
        
        jim.score.value = 66
        jim.score.value = 50
        
        player.value = tom
    }
    
    func demo1() {
        Observable.of(10, 22, 100).scan(1, accumulator: { (aggregateValue, newValue) in
            aggregateValue + newValue
        }).subscribe(onNext: { print($0) }).addDisposableTo(bag)
    }


    func demo2() {
        Observable.of(1, 1, 3, 3, 4, 2, 3, 3)
            .distinctUntilChanged().subscribe(onNext: { print($0)} )
            .addDisposableTo(bag)
    }
    
    func demo3() {
        Observable.of(1, 2, 4, 2, 3, 5)
            .takeWhileWithIndex { (element, index) -> Bool in
                index < 4
            }
            .subscribe(onNext: { print($0) })
            .addDisposableTo(bag)
        
        //        Observable.of(1, 3, 5, 6)
        //            .takeWhile { $0 < 6 }
        //            .subscribe(onNext: {print($0)})
        //            .addDisposableTo(bag)
    }
}

