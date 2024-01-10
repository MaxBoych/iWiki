//
//  ArticleCell.swift
//  iWiki
//
//  Created by Максим Бойчук on 29.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel?
    
    private var articleFeed: ExploreView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel?.text = nil
    }
    
    func configure(with articleName: String, articleFeed: ExploreView) {
        self.articleFeed = articleFeed
        
        guard let nameLabel = nameLabel else {
            return
        }
        
        nameLabel.text = articleName
    }
    
    func getName() -> String {
        guard let nameLabel = nameLabel else {
            return ""
        }
        
        return nameLabel.text!
    }
}
