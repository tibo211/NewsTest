//
//  SlideInViewController.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class SlideInViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var commentedArticleTableView: UITableView!
    
    var commentedArticles:[String] = []
    
    var pushCommentsView:((_ articleID:String)->())?
    
    enum SlideInState {
        case collapsed
        case expanded
    }
    
    var isSlidingIn = false
    
    var nextState:SlideInState {
        return isSlidingIn ? .collapsed : .expanded
    }
    
    var parentFrameHeight:CGFloat?
    var parentEffectView:UIVisualEffectView?
    
    var runningAnimations:[UIViewPropertyAnimator] = []
    var animationProgressWhenInterrupted:CGFloat = 0
    
    static var viewHeight:CGFloat = 500
    static var handleHeight:CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 12
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(recogizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleViewPan(recogizer:)))
        
        handleArea.addGestureRecognizer(tapGestureRecognizer)
        handleArea.addGestureRecognizer(panGestureRecognizer)
    }
}
