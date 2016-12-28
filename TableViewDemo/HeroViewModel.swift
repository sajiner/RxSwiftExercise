//
//  HeroViewModel.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/28.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift

class HeroViewModel {

    fileprivate lazy var bag: DisposeBag = DisposeBag()
    
    lazy var herosVariable: Variable<[Hero]> = {
        return Variable(self.getData())
    }()
    
    init(searchText: Observable<String>) {
      searchText.subscribe(onNext: { (str) in
        let heros = self.getData().filter({ (hero) -> Bool in
            if str == "" { return true }
            return hero.name.contains(str)
        })
        self.herosVariable.value = heros
      }).addDisposableTo(bag)
    }
    
}

extension HeroViewModel {
    fileprivate func getData() -> [Hero] {
        var heros: [Hero] = [Hero]()
        let path = Bundle.main.path(forResource: "heros.plist", ofType: nil)
        let dictArray = NSArray(contentsOfFile: path!) as! [[String : String]]
        for dict in dictArray {
            let hero = Hero(dict: dict)
            heros.append(hero)
        }
        return heros
    }
}
