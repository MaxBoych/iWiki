//
//  SignInModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 24.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class SignInModel {
    
    private let client = iWikiClient.shared
    
    func signIn(_ user: User, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        client.signInRequest(user: user, completion: completion)
    }
}
