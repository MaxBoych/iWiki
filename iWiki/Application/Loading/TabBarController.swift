//
//  TabBarController.swift
//  iWiki
//
//  Created by Максим Бойчук on 17.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
        
    private let profile = ProfileView()
    private let explore = ExploreView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        
        explore.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "globe")?.withRenderingMode(.alwaysTemplate),
            tag: 0
        )
        //explore.tabBarItem.selectedImage = UIImage(named: "globe")?.withRenderingMode(.alwaysOriginal)
        //explore.tabBarItem.image = UIImage(named: "globe")
        //explore.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //explore.tabBarItem.badgeColor = .black
        
        profile.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate),
            tag: 1
        )
        //profile.tabBarItem.selectedImage = UIImage(named: "person.fill")?.withRenderingMode(.alwaysOriginal)
        //profile.tabBarItem.image = UIImage(named: "person.fill")
        //profile.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //profile.tabBarItem.badgeColor = .black
        self.viewControllers = [explore, profile]
        self.selectedIndex = 0
    }
}
