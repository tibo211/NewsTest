//
//  DatabaseManager.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 26..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    
    static var articles:[String:ArticleData] = [:]
    
    static var sections:[String] = ["All"]
    
    static var ref:DatabaseReference = {
       return Database.database().reference()
    }()
    
    static func loadArticles(_ valueChanged:@escaping ()->()){
        
        ref.child("news").observe(.value) { (snapshot) in
            let articleData = snapshot.value  as? [String:AnyObject] ?? [:]
            
            articles = [:]
            sections = ["All"]
            
            for data in articleData {
                articles[data.key] = ArticleData(article: data.value as! [String : AnyObject])
            }
            
            //reload sections
            articles.forEach({ (data) in
                if !sections.contains(data.value.category) {
                    sections.append(data.value.category)
                }
            })
            
            //callback to change views
            valueChanged()
        }
    }
    
    
}
