//
//  ArticleViewController.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class ArticleViewController:UIViewController {
    
    var article:ArticleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func set(_ article:ArticleData){
        print("set article")
        self.article = article
    }
}
