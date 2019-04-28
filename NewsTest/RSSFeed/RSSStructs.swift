//
//  RSSStructs.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 28..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import Foundation

struct RSSBase:Decodable {
    let status:String
    let totalResults:Int
    let articles:[RSSArticle]?
}

struct RSSArticle:Decodable {
    let author:String?
    let title:String?
    let urlToImage:String?
    let publishedAt:String?
    let content:String?
    
    func getFirebaseNode(category:String) -> [String:String] {
        return [
            "category":category,
            "title":title ?? "",
            "author":author ?? "",
            "urlToImage":urlToImage ?? "",
            "publishedAt":publishedAt ?? "",
            "content":content ?? ""
        ]
    }
}
