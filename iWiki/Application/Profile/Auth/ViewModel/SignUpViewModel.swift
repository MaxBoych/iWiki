//
//  SignUpViewModel.swift
//  iWiki
//
//  Created by Максим Бойчук on 19.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewModel {
    
    private let model = SignUpModel()
    
    func signUp(_ user: User, completion: @escaping (iWikiClient.Status) -> ()) {
        model.signUp(user, completion: completion)
    }
}
