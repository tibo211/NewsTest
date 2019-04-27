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
        
        //setup slideInViewController which contains the comment table
        addChild(slideInViewController)
        view.addSubview(slideInViewController.view)
        slideInViewController.view.frame = CGRect(x: 0,
                                                  y: view.frame.height - SlideInViewController.handleHeight,
                                                  width: view.bounds.width,
                                                  height: SlideInViewController.viewHeight)
        slideInViewController.parentFrameHeight = view.frame.height
        slideInViewController.parentEffectView = visualEffectView
        
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


