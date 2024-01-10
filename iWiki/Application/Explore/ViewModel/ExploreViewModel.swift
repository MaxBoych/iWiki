//
//  ExploreViewModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 29.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

class ExploreViewModel {
    
    let model: ExploreModel = ExploreModel()
    
    func loadAllArticles(completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        model.loadAllArticles(completion: completion)
    }
    
    func loadArticlesByFilter(query: String, category: String, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        model.loadArticlesByFilter(query: query, category: category, completion: completion)
    }
}
