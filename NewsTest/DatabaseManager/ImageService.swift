//
//  ImageService.swift
//  NewsTest
//
//  Created by Felföldy Tibor on 2019. 04. 27..
//  Copyright © 2019. Felföldy Tibor. All rights reserved.
//

import UIKit

class ImageService {
    
    static var downloadedImages:[String:UIImage] = [:]
    
    static func getImage(withURL urls:String, completion: @escaping (_ url:String, _ image:UIImage?)->()) {
        guard !downloadedImages.keys.contains(urls) else {
            completion(urls, downloadedImages[urls])
            return
        }
        
        guard let url = URL(string: urls) else {
            print("the url is wrong: \(urls)")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                if let image = UIImage(data: data) {
                    downloadedImages[urls] = image
                }
            }
            
            DispatchQueue.main.async {
                if downloadedImages.keys.contains(urls){
                    completion(urls, downloadedImages[urls])
                } else {
                    completion(urls, nil)
                }
            }
            
        }
        
        dataTask.resume()
    }
}
