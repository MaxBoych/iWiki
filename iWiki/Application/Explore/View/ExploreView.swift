//
//  ExploreView.swift
//  iWiki
//
//  Created by Максим Бойчук on 17.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class ExploreView: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar?
    @IBOutlet private weak var articleFeed: UITableView?
    @IBOutlet private weak var errorLabel: UILabel?
    
    @IBAction func refreshButton(_ sender: UIButton) {
        loadAllArticles()
    }
    
    @IBAction func addNewButton(_ sender: UIButton) {
        let newArticleView = NewArticleView()
        self.present(newArticleView, animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectCategoryView: UIButton?
    @IBAction func selectCategoryButton(_ sender: UIButton) {
        categoryMenu.show()
    }
    
    private var articles = [String]()
    
    private var categoryName = ""
    private let categoryMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = Categories.names
        
        return menu
    }()
    
    private let viewModel: ExploreViewModel = ExploreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        guard let articleFeed = articleFeed, let errorLabel = errorLabel else {
            return
        }
        
        articleFeed.dataSource = self
        articleFeed.delegate = self
        articleFeed.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
        
        searchBar?.delegate = self
        
        errorLabel.alpha = 0
        
        setupCategoryMenu()
        
        loadAllArticles()
        
        //setupSearchBar()
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
    
    /*private func setupSearchBar() {
     guard let searchBar = searchBar else {
     return
     }
     
     searchBar.scopeButtonTitles = ["Music", "Math", "Animals", "Literature", "Programming"]
     searchBar.showsScopeBar = true
     searchBar.sizeToFit()
     }*/
    
    private func loadAllArticles() {
        viewModel.loadAllArticles(completion: { [weak self] (status, data) in
            guard let self = self else { return }
            if let errorMessage = self.handleError(status: status) {
                self.showError(message: errorMessage)
            } else {
                guard let articlesData = data,
                    let articles = try? JSONDecoder().decode([String].self, from: articlesData)
                    else {
                        self.showError(message: "Failed to parse articles data. Try again.")
                        return
                }
                print(articles)
                self.reloadArticles(articles: articles)
            }
        })
    }
    
    private func reloadArticles(articles: [String]) {
        guard let articleFeed = articleFeed else {
            return
        }
        self.articles = articles
        articleFeed.reloadData()
    }
}

extension ExploreView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let articleFeed = articleFeed,
            let cell = articleFeed.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell            else {
                let cell = ArticleCell()
                return cell
        }
        
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        
        let articleName = articles[indexPath.row]
        cell.configure(with: articleName, articleFeed: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleCell
            else {
                self.showError(message: "smth")
                return
        }
        
        let articleName = cell.getName()
        let articleView = ArticleView()
        articleView.setArticleName(name: articleName)
        self.present(articleView, animated: true, completion: nil)
    }
}

extension ExploreView {
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

extension ExploreView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadArticlesByFilter(query: searchText)
    }
    
    private func loadArticlesByFilter(query: String) {
        print("qwerty123")
        viewModel.loadArticlesByFilter(query: query, category: self.categoryName,
                                       completion: { [weak self] (status, data) in
                                        guard let self = self else { return }
                                        if let errorMessage = self.handleError(status: status) {
                                            self.showError(message: errorMessage)
                                        } else {
                                            guard let articlesData = data,
                                                let articles = try? JSONDecoder().decode([String].self, from: articlesData)
                                                else {
                                                    self.showError(message: "Failed to parse articles data. Try again.")
                                                    return
                                            }
                                            print(articles)
                                            self.reloadArticles(articles: articles)
                                        }
        })
    }
}

extension ExploreView {
    private func createNewArticle() {
        
    }
}
