//
//  ArticleView.swift
//  iWiki
//
//  Created by Максим Бойчук on 08.08.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

struct ImageContent {
    var textBeforeImage: String?
    var imageName: String?
}

class ArticleView: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var categoryLabel: UILabel?
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var errorLabel: UILabel?
    
    @IBOutlet private weak var editImage: UIImageView?
    @IBOutlet private weak var linkImage: UIImageView?
    @IBOutlet private weak var previousVersionsImage: UIImageView?
    
    private var articleName: String = ""
    
    private let viewModel = ArticleViewModel()
    
    func setArticleName(name: String) {
        articleName = name
    }
    
    /*override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
     
     scrollView?.contentSize = contentView?.frame.size as! CGSize
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let contentLabel = UILabel()
         contentLabel.text = "eheheheheheeeeeey"
         contentLabel.lineBreakMode = .byWordWrapping
         contentLabel.contentMode = .left
         contentLabel.numberOfLines = 0
         contentLabel.alpha = 1
         contentLabel.backgroundColor = .red
         contentView?.addSubview(contentLabel)
         
         /*NSLayoutConstraint.activate([
         contentLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView!.centerXAnchor, multiplier: 0.0),
         contentLabel.centerYAnchor.constraint(equalToSystemSpacingBelow: contentView!.centerYAnchor, multiplier: 0.0)
         ])*/
         
         NSLayoutConstraint.activate([
         contentLabel.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 0.0),
         contentLabel.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: 0.0),
         contentLabel.topAnchor.constraint(equalTo: categoryLabel!.bottomAnchor, constant: 0.0)
         ])
         
         contentLabel.translatesAutoresizingMaskIntoConstraints = false*/
        
        configure()
    }
    
    private func configure() {
        guard let errorLabel = errorLabel else {
            return
        }
        
        errorLabel.alpha = 0
        
        viewModel.loadArticle(name: articleName, completion: { [weak self] (status, data) in
            guard let self = self else { return }
            if let errorMessage = self.handleError(status: status) {
                self.showError(message: errorMessage)
            } else {
                guard let articleData = data,
                    let article = try? JSONDecoder().decode(Article.self, from: articleData)
                    else {
                        self.showError(message: "Failed to parse articles data. Try again.")
                        return
                }
                print(article)
                
                self.setAricleData(article: article)
            }
        })
    }
}

extension ArticleView {
    private func setAricleData(article: Article) {
        guard let scrollView = scrollView, let nameLabel = nameLabel, let categoryLabel = categoryLabel else {
            return
        }
        
        //print("HeRe")
        nameLabel.text = article.Name
        //print("category = \(article.Category)")
        categoryLabel.text = article.Category
        
        var content = article.ModifiedArticleData!
        content = removeLinks(content: content)
        let splittedContent = splitContent(content: content)
        print("ekk")
        print(splittedContent)
        postContent(splitContent: splittedContent)
        
        
    }
    
    private func removeLinks(content: String) -> String {
        let linkRegex = try! NSRegularExpression(
            //pattern: #"!\[lnk/([a-zA-Z0-9]+)\]\((a-zA-Z0-9)\)"#,
            pattern: #"!\[lnk/([a-zA-Z0-9]+)\]\(([a-zA-Z0-9]+)\)"#,
            options: .caseInsensitive
        )
        
        let range = NSRange(location: 0, length: content.utf16.count)
        let matches = linkRegex.matches(in: content, options: [], range: range)
        var nsstring = content as NSString
        var lastDeletedLength = 0
        print("lol")
        for match in matches {
            let firstRange = NSRange(location: match.range(at: 0).lowerBound - lastDeletedLength,
                                     length: match.range(at: 0).length)
            let secondRange = NSRange(location: match.range(at: 1).lowerBound - lastDeletedLength,
                                      length: match.range(at: 1).length)
            let thirdRange = NSRange(location: match.range(at: 2).lowerBound - lastDeletedLength,
                                     length: match.range(at: 2).length)
            
            //print("HERE1")
            //print(nsstring)
            //print(nsstring.substring(with: firstRange))
            //print(nsstring.substring(with: secondRange))
            
            let filtered = nsstring.replacingCharacters(
                in: firstRange,
                with: nsstring.substring(with: thirdRange) + "(\(nsstring.substring(with: secondRange)))"
            )
            
            lastDeletedLength += match.range(at: 0).length - match.range(at: 1).length - match.range(at: 2).length - 2
            
            /*let filtered = linkRegex.stringByReplacingMatches(
             //in: String(nsstring.substring(with: match.range(at: 0))),
             in: String(nsstring),
             options: [],
             range: range,
             withTemplate: String(nsstring.substring(with: match.range(at: 2)))
             )*/
            print("HERE2")
            print(filtered)
            //nsstring = filtered as NSString
            
            //range = NSRange(location: 0, length: filtered.utf16.count)
            //matches = linkRegex.matches(in: filtered, options: [], range: range)
            nsstring = filtered as NSString
        }
        
        print(nsstring)
        
        return nsstring as String
    }
    
    private func splitContent(content: String) -> [ImageContent] {
        let imageRegex = try! NSRegularExpression(
            pattern: #"!\[img/([a-zA-Z0-9]+)\]"#,
            options: .caseInsensitive
        )
        
        let text = content//.trimmingCharacters(in: .whitespacesAndNewlines)
        var changingText = text
        //print("changingText here")
        //print(changingText)
        let nsstring: NSString = text as NSString
        
        let range = NSRange(location: 0, length: text.utf16.count)
        
        let matches = imageRegex.matches(in: text, options: [], range: range)
        var splittedContent = [ImageContent]()
        var lastDeletedLength = 0
        if matches.isEmpty {
            let imageContent = ImageContent(
                textBeforeImage: text,
                imageName: nil
            )
            splittedContent.append(imageContent)
        } else {
            for match in matches {
                print("#####")
                print(changingText.count)
                print(changingText)
                print(match.range(at: 0))
                print(lastDeletedLength)
                print(match.range(at: 0).lowerBound)
                print(match.range(at: 0).upperBound)
                let imageContent = ImageContent(
                    textBeforeImage: String(changingText.prefix(match.range(at: 0).lowerBound - lastDeletedLength)),
                        //.trimmingCharacters(in: .whitespacesAndNewlines),
                    imageName: nsstring.substring(with: match.range(at: 1))
                )
                splittedContent.append(imageContent)
                changingText = String(changingText.dropFirst(match.range(at: 0).upperBound - lastDeletedLength))
                lastDeletedLength += (match.range(at: 0).upperBound - lastDeletedLength)
                
                /*print(match.range(at: 0))
                 print(match.range(at: 0).lowerBound)
                 print(match.range(at: 0).upperBound)
                 print(match.range(at: 1))
                 print(match.range(at: 1).lowerBound)
                 print(match.range(at: 1).upperBound)
                 print(nsstring.substring(with: match.range(at: 0)))
                 print(nsstring.substring(with: match.range(at: 1)))*/
            }
            
            if !changingText.isEmpty {
                let imageContent = ImageContent(
                    textBeforeImage: changingText,//.trimmingCharacters(in: .whitespacesAndNewlines),
                    imageName: nil
                )
                splittedContent.append(imageContent)
            }
        }
        
        print(splittedContent)
        
        return splittedContent
        
        //let new = imageRegex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        //print(new)
    }
    
    private func postContent(splitContent: [ImageContent]) {
        guard let contentView = contentView, let nameLabel = nameLabel, let categoryLabel = categoryLabel else {
            return
        }
        
        var lastView: UIView = categoryLabel
        for elem in splitContent {
            if (elem.textBeforeImage != nil) {
                let contentLabel = UILabel()
                contentLabel.text = elem.textBeforeImage
                contentLabel.lineBreakMode = .byWordWrapping
                contentLabel.contentMode = .left
                contentLabel.numberOfLines = 0
                contentView.addSubview(contentLabel)
                
                NSLayoutConstraint.activate([
                    contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
                    contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
                    contentLabel.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 0.0)
                ])
                contentLabel.translatesAutoresizingMaskIntoConstraints = false
                lastView = contentLabel
                //stackView.layoutIfNeeded()
                
                if (elem.imageName != nil) {
                    let imageView = UIImageView()
                    imageView.image = UIImage(systemName: "ellipsis.circle")
                    viewModel.loadImage(imageName: elem.imageName!, articleName: nameLabel.text!, completion: {
                        [weak self] (status, data) in
                        guard let self = self else { return }
                        if let errorMessage = self.handleError(status: status) {
                            self.showError(message: errorMessage)
                        } else if let data = data {
                            imageView.image = UIImage(data: data)
                            let targetSize = CGSize(width: 300, height: 200)
                            imageView.image = imageView.image?.scalePreservingAspectRatio(targetSize: targetSize)
                        }
                    })
                    
                    //imageView.frame = imageView.contentClippingRect
                    contentView.addSubview(imageView)
                    
                    NSLayoutConstraint.activate([
                        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
                        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
                        imageView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 0.0)/*,
                         imageView.widthAnchor.constraint(equalToConstant: 300),
                         imageView.heightAnchor.constraint(equalToConstant: 200)*/
                    ])
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    lastView = imageView
                }
            } else {
                let imageView = UIImageView()
                imageView.image = UIImage(systemName: "ellipsis.circle")
                viewModel.loadImage(imageName: elem.imageName!, articleName: nameLabel.text!, completion: {
                    [weak self] (status, data) in
                    guard let self = self else { return }
                    if let errorMessage = self.handleError(status: status) {
                        self.showError(message: errorMessage)
                    } else {
                        imageView.image = UIImage(data: data!)
                        let targetSize = CGSize(width: 300, height: 200)
                        imageView.image = imageView.image?.scalePreservingAspectRatio(targetSize: targetSize)
                    }
                })
    
                //imageView.frame = imageView.contentClippingRect
                contentView.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0.0),
                    imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0.0),
                    imageView.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 0.0)/*,
                     imageView.widthAnchor.constraint(equalToConstant: 300),
                     imageView.heightAnchor.constraint(equalToConstant: 200)*/
                ])
                imageView.translatesAutoresizingMaskIntoConstraints = false
                lastView = imageView
            }
        }
        
        NSLayoutConstraint.activate([
            lastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.layoutIfNeeded()
    }
    
    private func setPreviousVersions(versions: [String]) {
        
    }
    
    private func setLinksHere(links: [String]) {
        
    }
}

extension ArticleView {
    private func handleError(status: iWikiClient.Status) -> String? {
        switch status {
        case .OK:
            return nil
        case .BadRequest:
            return "Bad request. Try again."
        case .Unauthorized:
            return "Unathorized request."
        case .NotFound:
            return "Article not found."
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

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

/*extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}*/
