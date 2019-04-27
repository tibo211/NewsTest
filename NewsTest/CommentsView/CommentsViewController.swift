//
//  CommentsViewController.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var commentsTableView: UITableView!
    
    var comments:[String] = []
    
    func set(_ comments:[String]) {
        self.comments = comments
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNIB = UINib(nibName: "CommentViewCell", bundle: nil)
        commentsTableView.register(cellNIB, forCellReuseIdentifier: "commentCell")
        commentsTableView.dataSource = self
        commentsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentViewCell
        cell.commentTextView.text = comments[indexPath.row]
        cell.commentPlaceHolder.layer.cornerRadius = 10
        return cell
    }
    
}
