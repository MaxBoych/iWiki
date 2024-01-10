//
//  NewImageAlertView.swift
//  iWiki
//
//  Created by Максим Бойчук on 05.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class NewImageAlertView: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet weak var imageNameTextField: UITextField?
    @IBOutlet private weak var errorLabel: UILabel?
    @IBOutlet private var backgroundView: UIView?
    
    private var viewController: NewArticleView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        guard let errorLabel = errorLabel else {
            return
        }
        
        errorLabel.alpha = 0
        
        setupImageImport()
    }
    
    @IBAction func addImageButton(_ sender: UIButton) {
        guard let imageView = imageView, let imageNameTextField = imageNameTextField,
            let viewController = viewController else {
                return
        }
        
        let image = imageView.image
        if image == nil {
            showError(message: "The image must not be empty")
            return
        }
        
        let name = imageNameTextField.text
        if name == nil || name == "" {
            showError(message: "The image name must not be empty")
            return
        }
        
        guard let pngData = image?.pngData() else {
            showError(message: "Cannot convert image data. Try again.")
            return
        }
        
        let imageData = ImageData(Name: name!, Image: pngData)
        if viewController.checkImageName(name: name!) {
            showError(message: "Image name \"\(name!)\" is used more than once. Please rename.")
            return
        }
        viewController.addImage(imageData: imageData)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setViewController(viewController: NewArticleView) {
        self.viewController = viewController
    }
    
    func showError(message: String) {
        print("HERE")
        guard let errorLabel = errorLabel else {
            return
        }
        errorLabel.textAlignment = .center
        errorLabel.text = message
        errorLabel.alpha = 1.0
        errorLabel.layer.cornerRadius = 16;
        errorLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4.0, delay: 4.0, options: .curveEaseOut, animations: {
            errorLabel.alpha = 0.0
        })
    }
}

extension NewImageAlertView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setupImageImport() {
        guard let imageView = imageView else {
            return
        }
        
        let clicked = UITapGestureRecognizer(target: self, action: #selector(importPicture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(clicked)
    }
    
    @objc private func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        dismiss(animated: true)
        
        imageView?.image = image
    }
}

extension NewImageAlertView {
    
    private func registerNotifications() {
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardFunc))
        guard let backgroundView = backgroundView else { return }
        backgroundView.addGestureRecognizer(hideKeyboard)
    }
    
    @objc private func hideKeyboardFunc() {
        guard let backgroundView = backgroundView else { return }
        backgroundView.endEditing(true)
    }
}
