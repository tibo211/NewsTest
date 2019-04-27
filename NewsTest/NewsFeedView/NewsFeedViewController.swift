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
    
    var selectedArticleIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsFeedTableView.rowHeight = newsFeedTableView.bounds.width / 2
        
        DatabaseManager.loadArticles {
            self.menuBarView.selectedIndex = -1
            self.menuBarView.categoryCollectionView.reloadData()
        }
        
        menuBarView.updateTableView = {
            category in
            self.filteredArticleIDs = DatabaseManager.getArticleIDs(byCategory: category)
            
            self.newsFeedTableView.reloadData()
            
            DatabaseManager.articles
                .filter{self.filteredArticleIDs.contains($0.key)}
                .map{ $0.value.imageURL }
                .forEach{
                    ImageService.getImage(withURL: $0, completion: { (url, image) in
                        if image != nil {
                            self.loadImage(url: url, image: image!)
                        }
                    })
            }
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsFeedTableView.delegate = self
        newsFeedTableView.dataSource = self
    }
    
    func loadImage(url:String,image:UIImage){
        for cell in newsFeedTableView.visibleCells {
            let cell = cell as! ArticleCell
            if cell.imgURL == url {
                cell.articleImageView.image = image
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //should not stay selected
        tableView.deselectRow(at: indexPath, animated: true)
        selectedArticleIndex = indexPath.row
        performSegue(withIdentifier: "showArticleDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ArticleViewController {
            let articleID = filteredArticleIDs[selectedArticleIndex]
            guard let article = DatabaseManager.articles[articleID] else { return }
            destination.set(article)
        }
    }
}


