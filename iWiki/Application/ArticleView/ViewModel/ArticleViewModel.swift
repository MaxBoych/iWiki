//
//  ArticleViewModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 08.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

class ArticleViewModel {
    
    private let model = ArticleModel()
    
    func loadArticle(name: String, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        model.loadArticle(name: name, completion: completion)
    }
    
    func loadImage(imageName: String, articleName: String, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        model.loadImage(imageName: imageName, articleName: articleName, completion: completion)
    }
}
