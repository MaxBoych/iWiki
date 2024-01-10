//
//  NewArticleView.swift
//  iWiki
//
//  Created by Максим Бойчук on 03.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class NewArticleView: UIViewController {
    
    @IBOutlet private weak var articleNameTextField: UITextField?
    @IBOutlet private weak var articleDataTextView: UITextView?
    @IBOutlet private weak var imageList: UICollectionView?
    @IBOutlet weak var addNewImage: UIImageView?
    @IBOutlet weak var errorLabel: UILabel?
    
    private var images = [ImageData]()
    
    @IBOutlet weak var selectCategoryView: UIButton?
    @IBAction func selectCategoryButton(_ sender: UIButton) {
        categoryMenu.show()
    }
    
    private var categoryName = ""
    private let categoryMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = Categories.names
        
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        guard let imageList = imageList, let errorLabel = errorLabel, let addNewImage = addNewImage else {
            return
        }
        
        imageList.dataSource = self
        imageList.delegate = self
        imageList.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        
        errorLabel.alpha = 0
        
        setupCategoryMenu()
        
        let clicked = UITapGestureRecognizer(target: self, action: #selector(addNewImageAction))
        addNewImage.isUserInteractionEnabled = true
        addNewImage.addGestureRecognizer(clicked)
    }
    
    private func setupCategoryMenu() {
        guard let selectCategoryView = selectCategoryView else {
            return
        }
        
        categoryMenu.anchorView = selectCategoryView
        categoryMenu.selectionAction = { _, title in
            if title == "---" {
                self.categoryName = ""
                selectCategoryView.setTitle("Select category", for: .normal)
            } else {
                self.categoryName = title
                selectCategoryView.setTitle(title, for: .normal)
            }
        }
    }
    
    @objc private func addNewImageAction() {
        let newImageAlertView = NewImageAlertView()
        newImageAlertView.setViewController(viewController: self)
        self.present(newImageAlertView, animated: true, completion: nil)
    }
    
    private let viewModel = NewArticleViewModel()
    
    @IBAction func createArticle(_ sender: UIButton) {
        guard let articleNameTextField = articleNameTextField, let articleDataTextView = articleDataTextView else {
            return
        }
        
        let name = articleNameTextField.text
        let content = articleDataTextView.text
        if (name == nil || name == "") {
            showError(message: "The article name must not be empty")
            return
        }
        if (content == nil || content == "") {
            showError(message: "The article content must not be empty")
            return
        }
        
        guard let user = (try? UserDefaults.standard.getObject(User.self, forKey: "CurrentUser")),
            let username = user.Username else {
                showError(message: "To create an article you must be authenticated")
                return
        }
        let article = Article(Name: name, Category: categoryName, AuthorUsername: username,
                              ModifiedArticleData: content, ModifiedDate: nil)
        
        var jsonImages = ""
        do {
            let jsonData = try JSONEncoder().encode(images)
            guard let json = String(data: jsonData, encoding: .utf8) else {
                showError(message: "Cannot convert images to json. Try again.")
                return
            }
            jsonImages = json
        } catch {
            showError(message: "Cannot convert images to data. Try again.")
            return
        }
        
        viewModel.createArticle(article: article, images: jsonImages, completion: { [weak self] (status) in
            guard let self = self else { return }
            if let errorMessage = self.handleError(status: status) {
                self.showError(message: errorMessage)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func checkData(name: String?, content: String?) -> String? {
        if (name == nil || name == "") {
            return "The article name must not be empty"
        }
        if (content == nil || content == "") {
            return "The article content must not be empty"
        }
        
        for image in images {
            if (image.Name == "") {
                return "The image name must not be empty"
            }
            
            var count = 0
            for image2 in images {
                if image == image2 {
                    count += 1
                    if (count == 2) {
                        return "Image name \"\(image.Name)\" is used more than once"
                    }
                }
            }
        }
        
        return nil
    }
}

extension NewArticleView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let imageList = imageList, let cell = imageList.dequeueReusableCell(withReuseIdentifier: "ImageCell",
                                                                                  for: indexPath) as? ImageCell else {
                                                                                    return ImageCell()
        }
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        let data = images[indexPath.row]
        cell.configure(imageData: data.Image, imageName: data.Name, viewController: self)
        
        return cell
    }
    
    func checkImageName(name: String) -> Bool {
        for image in images {
            if image.Name == name {
                return true
            }
        }
        return false
    }
    
    func addImage(imageData: ImageData) {
        guard let imageList = imageList else {
            return
        }
        
        images.append(imageData)
        let indexPath = IndexPath(row: images.count - 1, section: 0)
        imageList.insertItems(at: [indexPath])
    }
    
    func removeImage(name: String) {
        let index = images.firstIndex { $0.Name == name }
        
        guard let imageList = imageList, let deletedIndex = index else {
            return
        }
        
        images.remove(at: deletedIndex)
        let indexPath = IndexPath(row: deletedIndex, section: 0)
        imageList.deleteItems(at: [indexPath])
    }
}

/*extension NewArticleView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setupImageImport() {
        guard let addNewImage = addNewImage else {
            return
        }
        
        let clicked = UITapGestureRecognizer(target: self, action: #selector(importPicture))
        addNewImage.isUserInteractionEnabled = true
        addNewImage.addGestureRecognizer(clicked)
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
        
        addImage(image: image)
    }
}*/

extension NewArticleView: UITextFieldDelegate, UITextViewDelegate {
    
}

extension NewArticleView {
    private func handleError(status: iWikiClient.Status) -> String? {
        switch status {
        case .OK:
            return nil
        case .BadRequest:
            return "Bad request. Try again."
        case .Unauthorized:
            return "Unathorized request."
        case .InternalError:
            return "Internal server error. Try again."
        case .Unreachable:
            return "Server is not available. Try again."
        case .UnknownError:
            return "Unknown error occurred. Try again."
        default:
            print(status)
            return "???"
        }
    }
    
    func showError(message: String) {
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
