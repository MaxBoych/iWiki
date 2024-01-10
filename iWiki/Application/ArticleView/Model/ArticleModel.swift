//
//  ArticleModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 08.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

class ArticleModel {
    
    private let client = iWikiClient.shared
    
    func loadArticle(name: String, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        client.loadArticle(name: name, completion: completion)
    }
    
    func loadImage(imageName: String, articleName: String, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        client.loadImage(imageName: imageName, articleName: articleName, completion: completion)
    }
}
