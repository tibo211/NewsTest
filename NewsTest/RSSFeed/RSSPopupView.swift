//
//  RSSPopupView.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 28..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class RSSPopupView: UIView {
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var articleIsUploaded:(()->())?
    
    enum RSSState{
        case categorySelection
        case articleSelection
    }
    
    var state = RSSState.categorySelection
    
    let categories = ["Politics", "Sports", "Finance", "Lifestyle"]
    var articles:[RSSArticle] = []
    var selectedCategory:String = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        layer.cornerRadius = 10
    }
    
    @IBAction func onTouchCancel(_ sender: Any) {
        state = .categorySelection
        guard let dissmiss = articleIsUploaded else { return }
        dissmiss()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension RSSPopupView:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .categorySelection:
            return categories.count
        case .articleSelection:
            return articles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .categorySelection:
            var cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
            }
            
            cell!.textLabel?.text = categories[indexPath.row]
            return cell!
        case .articleSelection:
            var cell = tableView.dequeueReusableCell(withIdentifier: "rssArticleCell")
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "rssArticleCell")
            }
            
            cell!.textLabel?.text = articles[indexPath.row].title ?? ""
            cell!.detailTextLabel?.text = articles[indexPath.row].author ?? ""
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch state {
        case .categorySelection:
            tableView.isUserInteractionEnabled = false
            let category = categories[indexPath.row]
            RSSManager.getFeeds(category: category) { (articles) in
                self.articles = articles
                self.state = .articleSelection
                self.selectedCategory = category
                
                DispatchQueue.main.async {
                    tableView.isUserInteractionEnabled = true
                    tableView.reloadData()
                    self.instructionLabel.text = "Select article"
                }
            }
        case .articleSelection:
            DatabaseManager.upload(articles[indexPath.row], withCategory: selectedCategory)
            state = .categorySelection
            guard let uploaded = articleIsUploaded else { return }
            uploaded()
            break
        }
        
    }
}
