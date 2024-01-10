//
//  ExploreModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 29.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

class ExploreModel {
    
    private let client = iWikiClient.shared
    
    func loadAllArticles(completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        client.loadAllArticles(completion: completion)
    }
    
    func loadArticlesByFilter(query: String, category: String, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        client.loadArticlesByFilter(query: query, category: category, completion: completion)
    }
}
