//
//  ViewController.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 25..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    @IBOutlet weak var menuBarView: MenuBarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        menuBarView.menuCollectionView.allowsSelection = true
    }

}


