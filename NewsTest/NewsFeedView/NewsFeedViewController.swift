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
    @IBOutlet weak var newsFeedTableView: UITableView!
    
    var filteredArticleIDs:[String] = []
    let cellID = "articleCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeedTableView.rowHeight = newsFeedTableView.bounds.width / 2
        
        DatabaseManager.loadArticles {
            self.menuBarView.categoryCollectionView.reloadData()
        }
        
        menuBarView.updateTableView = {
            category in
            self.filteredArticleIDs = DatabaseManager.getArticleIDs(byCategory: category)
            
            self.newsFeedTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
    }

}

extension NewsFeedViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticleIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleData = DatabaseManager.articles[filteredArticleIDs[indexPath.row]] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ArticleCell
        
        cell.set(withData: articleData)
        
        return cell
    }
    
    
}


