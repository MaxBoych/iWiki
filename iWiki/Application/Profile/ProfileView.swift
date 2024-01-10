//
//  ProfileView.swift
//  iWiki
//
//  Created by Максим Бойчук on 17.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var roleLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        
        //let signInView = SignInView()
        ////signInView.modalPresentationStyle = .overCurrentContext
        //self.present(signInView, animated: true, completion: nil)
        //return
        
        guard let user = (try? UserDefaults.standard.getObject(User.self, forKey: "CurrentUser")) else {
            let signInView = SignInView()
            //signInView.modalPresentationStyle = .overCurrentContext
            self.present(signInView, animated: true, completion: nil)
            return
        }
        
        guard let nameLabel = nameLabel, let usernameLabel = usernameLabel, let roleLabel = roleLabel,
            let locationLabel = locationLabel else {
                return
        }
        
        nameLabel.text = user.Name
        usernameLabel.text = user.Username
        locationLabel.text = user.Location
        switch (user.Role) {
        case 0:
            roleLabel.text = "user"
        case 1:
            roleLabel.text = "moder"
        case 2:
            roleLabel.text = "admin"
        default:
            roleLabel.text = "..."
        }
    }
}
