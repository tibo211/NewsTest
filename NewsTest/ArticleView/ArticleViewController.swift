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
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var popupTextView: UITextView!
    
    @IBOutlet var popupView: UIView!
    
    var article:ArticleData?
    var articleID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.effect = nil
        
        popupView.layer.cornerRadius = 10
    }
    
    func loadData(){
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
    
    func set(_ articleID:String){
        article = DatabaseManager.articles[articleID]
        self.articleID = articleID
    }
   
    @IBAction func commentButton(_ sender: Any) {
        showPopupView()
    }
    
    func showPopupView(){
        view.addSubview(visualEffectView)
        view.addSubview(popupView)
        
        popupView.center = view.center
        popupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popupView.alpha =  0
        popupTextView.becomeFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.effect = UIBlurEffect(style: .dark)
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func touchDissmiss(_ sender: Any) {
        hidePopupView()
    }
    
    func hidePopupView(){
        let comment = popupTextView.text
        popupTextView.text = ""
        
        if comment != "" {
            DatabaseManager.add(comment: comment!, forArticle: articleID!)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popupView.alpha = 1
            self.visualEffectView.effect = nil
        }) { (success) in
            self.popupView.removeFromSuperview()
        }
        
    }
    
}
