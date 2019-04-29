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
    @IBOutlet var popupView: RSSPopupView!
    
    var updateArticleView:(()->())?
    
    var filteredArticleIDs:[String] = []
    var selectedCommentsArticleID:String?
    let cellID = "articleCellID"
    
    var selectedArticleIndex = 0
    
    lazy var visualEffectView:UIVisualEffectView = {
        let effectView = UIVisualEffectView()
        return effectView
    }()
    
    lazy var slideInViewController:SlideInViewController = {
        let vc = SlideInViewController(nibName: "SlideInViewController", bundle: nil)
        vc.view.clipsToBounds = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visualEffectView.frame = self.view.frame
        visualEffectView.isUserInteractionEnabled = false
        view.addSubview(visualEffectView)
        
        setupSlideInView()
        
        newsFeedTableView.rowHeight = newsFeedTableView.bounds.width / 2
        newsFeedTableView.backgroundColor = .clear
        
        DatabaseManager.loadArticles {
            self.menuBarView.selectedIndex = -1
            self.menuBarView.categoryCollectionView.reloadData()
            self.slideInViewController.updateCommentViewList()
            if let updateArticleView = self.updateArticleView {
                updateArticleView()
            }
        }
        
        menuBarView.updateTableView = {
            category in
            self.filteredArticleIDs = DatabaseManager.getArticleIDs(byCategory: category)
            
            self.newsFeedTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { self.newsFeedTableView.setContentOffset(.zero, animated: false) })
            
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
    
    @IBAction func onTouchAddRSSFeed(_ sender: Any) {
        //TODO: show RSSPopup
        view.addSubview(popupView)
        
        popupView.center = view.center
        popupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popupView.alpha =  0
        UIView.animate(withDuration: 0.5) {
            if self.visualEffectView.effect == nil {
                self.visualEffectView.effect = UIBlurEffect(style: .dark)
            }
            self.popupView.alpha = 1
            self.popupView.transform = CGAffineTransform.identity
        }
        
        popupView.articleIsUploaded = hidePopupView
    }
    
    func hidePopupView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popupView.alpha = 1
            self.visualEffectView.effect = nil
        }) { (success) in
            self.popupView.removeFromSuperview()
        }
    }
    
    @IBAction func onTouchComments(_ sender: Any) {
        slideInViewController.animateTransition(duration: 1)
    }
    
    func setupSlideInView(){
        addChild(slideInViewController)
        view.addSubview(slideInViewController.view)
        slideInViewController.view.frame =
            CGRect(x: 0,
                   y: view.frame.height - SlideInViewController.handleHeight,
                   width: view.bounds.width,
                   height: SlideInViewController.viewHeight)
        slideInViewController.parentFrameHeight = view.frame.height
        slideInViewController.parentEffectView = visualEffectView
        SlideInViewController.viewHeight = newsFeedTableView.frame.height + menuBarView.frame.height + 60
        
        slideInViewController.pushCommentsView = {
            articleID in
            self.selectedCommentsArticleID = articleID
            self.performSegue(withIdentifier: "showComments", sender: self)
        }
    }
}


