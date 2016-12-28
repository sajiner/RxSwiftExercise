//
//  HerosViewController.swift
//  RxSwiftExercise
//
//  Created by sajiner on 2016/12/28.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HerosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    fileprivate lazy var heroVM: HeroViewModel = HeroViewModel(searchText: self.searchText)
    fileprivate var searchText: Observable<String> {
        return searchBar.rx.text.orEmpty.throttle(1, scheduler: MainScheduler.instance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heroVM.herosVariable.asObservable().bindTo(tableView.rx.items(cellIdentifier: "HeroCellID", cellType: UITableViewCell.self)){ (row, hero, cell) in
            cell.textLabel?.text = hero.name
            cell.detailTextLabel?.text = hero.intro
            cell.imageView?.image = UIImage(named: hero.icon)
        }.addDisposableTo(bag)
        
        tableView.rx.modelSelected(Hero.self).subscribe(onNext: { (hero) in
            print(hero.name)
        }).addDisposableTo(bag)
        
    }

}
