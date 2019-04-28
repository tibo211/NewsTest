//
//  RSSManager.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 28..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import Foundation

class RSSManager {
    
    static func getFeeds(category:String, completion: @escaping (_ articles:[RSSArticle])->()){
        let apiKey = "a7f75a89dc5f41f09d6f358abbb3de08"
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=\(category)&apiKey=\(apiKey)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let base = try JSONDecoder().decode(RSSBase.self, from: data)
                if base.articles != nil {
                    completion(base.articles!)
                } else {
                    completion([])
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
}
