//
//  Article.swift
//  iWiki
//
//  Created by Максим Бойчук on 29.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

struct Article: Decodable, Encodable, Equatable {
    
    var Name: String?
    var Category: String?
    var AuthorUsername: String?
    var ModifiedArticleData: String?
    var ModifiedDate: String?
    var PreviousVersions: [String]?
    var LinksHere: [String]?
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.Name == rhs.Name
    }
}

struct ImageData: Decodable, Encodable, Equatable {
    
    var Name: String
    var Image: Data
    
    static func == (lhs: ImageData, rhs: ImageData) -> Bool {
        return lhs.Name == rhs.Name
    }
}
