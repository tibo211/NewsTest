//
//  CommentsTableViewExtension.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

extension SlideInViewController:UITableViewDataSource, UITableViewDelegate {
    func updateCommentViewList(){
        commentedArticles = Array(DatabaseManager.articles.filter{ $0.value.comments.count > 0 }.map{$0.key})
        commentedArticleTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = DatabaseManager.articles[commentedArticles[indexPath.row]]
        var cell = tableView.dequeueReusableCell(withIdentifier: "commentArticleCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "commentArticleCell")
        }
        
        cell!.textLabel?.text = article!.title
        cell!.detailTextLabel?.text = "comments: \(article!.comments.count)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pushCommentsView = pushCommentsView else { return }
        pushCommentsView(commentedArticles[indexPath.row])
    }
}
