//
//  NewsFeedTableExtension.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

extension NewsFeedViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticleIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleData = DatabaseManager.articles[filteredArticleIDs[indexPath.row]] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ArticleCell
        cell.backgroundColor = .clear
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
            destination.set(articleID)
        }
        
        if let destination = segue.destination as? CommentsViewController {
            guard let articleID = selectedCommentsArticleID,
                let comments = DatabaseManager.articles[articleID]?.comments else { return }
            destination.set(comments)
        }
    }
}
