//
//  User.swift
//  iWiki
//
//  Created by Максим Бойчук on 19.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation

struct User: Decodable, Encodable, Equatable {
    var Username: String?
    var Password: String?
    var Name: String?
    var Location: String?
    var Role: Int?
    var RegistrationDate: String?
    var LastModifiedDate: String?
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.Username == rhs.Username
    }
    
    init(username: String, password: String) {
        Username = username
        Password = password
        Name = nil
        Location = nil
        Role = nil
        RegistrationDate = nil
        LastModifiedDate = nil
    }
    
    init(username: String, password: String, name: String, location: String) {
        Username = username
        Password = password
        Name = name
        Location = location
        Role = nil
        RegistrationDate = nil
        LastModifiedDate = nil
    }
    
    init(username: String, password: String, name: String, location: String, id: String,
         role: Int, registrationDate: String, lastModifiedDate: String) {
        Username = username
        Password = password
        Name = name
        Location = location
        Role = role
        RegistrationDate = registrationDate
        LastModifiedDate = lastModifiedDate
    }
}
