//
//  MenuBarItem.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 26..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class MenuBarItem: UICollectionViewCell {
    
    lazy var labelView:UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = "Test"
        labelView.textAlignment = .center
        return labelView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenuItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMenuItem()
    }
    
    
    func setupMenuItem(){
        contentView.addSubview(labelView)
        
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
    
    func set(text: String){
        labelView.text = text
    }
    
    func deselectMenuItem(){
        labelView.font = UIFont.boldSystemFont(ofSize: 20)
        labelView.textColor = .gray
    }
    
    func selectMenuItem(){
        labelView.font = UIFont.boldSystemFont(ofSize: 25)
        labelView.textColor = .white
    }
}
