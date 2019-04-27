//
//  ArticleViewController.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class ArticleViewController:UIViewController {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var article:ArticleData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let article = article else { return }
        titleLabel.text = article.title
        bodyTextView.text = article.content
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = dateFormatter.string(from: article.creation_date)
        
        ImageService.getImage(withURL: article.imageURL) { (_, image) in
            if image != nil {
                self.articleImage.image = image!
            }
        }
        
    }
    
    func set(_ article:ArticleData){
        self.article = article
    }
    
   
    @IBAction func commentButton(_ sender: Any) {
        
        
    }
    
}
