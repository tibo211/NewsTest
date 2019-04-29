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
    let creation_date:Date
    
    let comments:[String]
 
    init(article:[String:AnyObject]) {
        title = article["title"] as? String ?? ""
        creator = article["author"] as? String ?? ""
        imageURL = article["urlToImage"] as? String ?? ""
        content = article["content"] as? String ?? ""
        category = article["category"] as? String ?? ""
        
        let commentDic = article["comments"] as? [String:String] ?? nil
        
        if commentDic != nil {
            comments = Array(commentDic!.values)
        } else {
            comments = []
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
     
        guard let dateString = article["publishedAt"] as? String else {
            creation_date = Date()
            return
        }
        guard let date = dateFormatter.date(from: dateString) else {
           creation_date = Date()
            return
        }
        creation_date = date
    }
}
