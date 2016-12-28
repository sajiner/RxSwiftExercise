//
//  Hero.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/28.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

class Hero: NSObject {

    var intro: String = ""
    var name: String = ""
    var icon: String = ""
    
    init(dict: [String : String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}
