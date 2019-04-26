//
//  ArticleData.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 26..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

struct ArticleData {
    let title:String
    let creator:String
    let imageURL:String
    let content:String
    let category:String
    let creation_date:String
 
    init(article:[String:AnyObject]) {
        title = article["title"] as? String ?? ""
        creator = article["creator"] as? String ?? ""
        imageURL = article["image"] as? String ?? ""
        content = article["content"] as? String ?? ""
        creation_date = article["creation"] as? String ?? ""
        category = article["category"] as? String ?? ""
    }
}
