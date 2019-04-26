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
 
    init(article:[String:AnyObject]) {
        title = article["title"] as? String ?? ""
        creator = article["creator"] as? String ?? ""
        imageURL = article["image"] as? String ?? ""
        content = article["content"] as? String ?? ""
        category = article["category"] as? String ?? ""
        
        
        let dateFormatter = DateFormatter()
        //standard format
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        //set the date to 2000.01.01 if it cannot formate
        //because if Date is optional it can be a real pain when we need ordering
        guard let dateString = article["creation"] as? String else {
            creation_date = dateFormatter.date(from: "2000.01.01")!
            return
        }
        guard let date = dateFormatter.date(from: dateString) else {
            creation_date = dateFormatter.date(from: "2000.01.01")!
            return
        }
         
        creation_date = date

    }
}
