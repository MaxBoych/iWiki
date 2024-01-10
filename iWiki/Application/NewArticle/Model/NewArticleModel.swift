//
//  NewArticleModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 04.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

class NewArticleModel {
    
    private let client = iWikiClient.shared
    
    func createArticle(article: Article, images: String, completion: @escaping (iWikiClient.Status) -> ()) {
        client.createArticle(article: article, images: images, completion: completion)
    }
}
