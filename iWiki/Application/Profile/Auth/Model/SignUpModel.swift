//
//  SignUpModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 19.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class SignUpModel {
    
    private let client = iWikiClient.shared
    
    func signUp(_ user: User, completion: @escaping (iWikiClient.Status) -> ()) {
        client.signUpRequest(user: user, completion: completion)
    }
}
