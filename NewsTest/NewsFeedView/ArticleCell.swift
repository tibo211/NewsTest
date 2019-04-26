//
//  ArticleCell.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 26..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    var imgURL:String = ""
    
    func set(withData data:ArticleData) {
        titleLabel.text = data.title
        creatorLabel.text = data.creator
    }
}
