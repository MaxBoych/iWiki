//
//  SignInViewModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 24.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class SignInViewModel {
    
    private let model = SignInModel()
    
    func signIn(_ user: User, completion: @escaping (iWikiClient.Status, Data?) -> ()) {
        model.signIn(user, completion: completion)
    }
}
