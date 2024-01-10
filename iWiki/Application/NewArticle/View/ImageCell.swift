//
//  ImageCollectionCell.swift
//  iWiki
//
//  Created by Максим Бойчук on 03.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var imageNameLabel: UILabel?
    @IBOutlet private weak var removeImage: UIImageView?
    
    private var viewController: NewArticleView? = nil
    
    func configure(imageData: Data, imageName: String, viewController: NewArticleView) {
        guard let image = imageView, let imageNameLabel = imageNameLabel, let removeImage = removeImage else {
            return
        }
        
        self.viewController = viewController
        
        image.image = UIImage(data: imageData)
        imageNameLabel.text = imageName
        
        let clicked = UITapGestureRecognizer(target: self, action: #selector(removeImageClicked))
        removeImage.isUserInteractionEnabled = true
        removeImage.addGestureRecognizer(clicked)
    }
    
    @objc private func removeImageClicked() {
        guard let viewController = viewController, let imageNameLabel = imageNameLabel else {
            return
        }
        
        viewController.removeImage(name: imageNameLabel.text!)
    }
}
