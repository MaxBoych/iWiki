//
//  iWikiClient.swift
//  iWiki
//
//  Created by Максим Бойчук on 19.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import Alamofire

class iWikiClient {
    
    static let shared = iWikiClient()
    
    enum Status {
        case
        OK,
        BadRequest,
        Unauthorized,
        NotFound,
        Conflict,
        InternalError,
        UnknownError,
        Unreachable
        
        init(_ statusCode: Int?) {
            switch statusCode {
            case 200?:
                self = .OK
            case 400?:
                self = .BadRequest
            case 401?:
                self = .Unauthorized
            case 404?:
                self = .NotFound
            case 409?:
                self = .Conflict
            case 500?:
                self = .InternalError
            case 523?:
                self = .Unreachable
            default:
                self = .UnknownError
            }
        }
    }
    
    let baseUrl = "http://localhost:8080"
    
    func signInRequest(user: User, completion: @escaping (Status, Data?)->()) {
        AF.request(
            "\(baseUrl)/user/signin",
            method: .post,
            parameters: [
                "username": user.Username,
                "password": user.Password
            ]/*,
             headers: ["Content-Type": "application/json"]*/
        ).response { response in
            completion(.init(response.response?.statusCode), response.data)
        }
    }
    
    func signUpRequest(user: User, completion: @escaping (Status)->()) {
        AF.request(
            "\(baseUrl)/user/signup",
            method: .post,
            parameters: [
                "username": user.Username,
                "password": user.Password,
                "name": user.Name,
                "location": user.Location
            ]/*,
             headers: ["Content-Type": "application/json"]*/
        ).response { response in
            completion(.init(response.response?.statusCode))
        }
    }
    
    func loadAllArticles(completion: @escaping (Status, Data?) -> ()) {
        AF.request(
            "\(baseUrl)/articles/",
            method: .get
        ).response { response in
            completion(.init(response.response?.statusCode), response.data)
        }
    }
    
    func loadArticlesByFilter(query: String, category: String, completion: @escaping (Status, Data?) -> ()) {
        AF.request(
            "\(baseUrl)/articles/filtered",
            method: .get,
            parameters: [
                "query": query,
                "category": category
            ]
        ).response { response in
            completion(.init(response.response?.statusCode), response.data)
        }
    }
    
    func createArticle(article: Article, images: String, completion: @escaping (Status) -> ()) {
        AF.request(
            "\(baseUrl)/articles/create",
            method: .post,
            parameters: [
                "name": article.Name!,
                "category": article.Category!,
                "authorUsername": article.AuthorUsername!,
                "modifiedArticleData": article.ModifiedArticleData!,
                "images": images
            ]
        ).response { response in
            completion(.init(response.response?.statusCode))
        }
    }
    
    func loadArticle(name: String, completion: @escaping (Status, Data?) -> ()) {
        AF.request(
            "\(baseUrl)/articles/\(name)",
            method: .get
        ).response { response in
            completion(.init(response.response?.statusCode), response.data)
        }
    }
    
    func loadImage(imageName: String, articleName: String, completion: @escaping (Status, Data?) -> ()) {
        AF.request(
        "\(baseUrl)/articles/image",
            method: .get,
            parameters: [
                "name": imageName,
                //"articleName": articleName
            ]
        ).response { response in
            completion(.init(response.response?.statusCode), response.data)
        }
    }
}
