//
//  ViewController.swift
//  iWiki
//
//  Created by Максим Бойчук on 17.07.2020.
//  Copyright © 2020 bmstu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private let TabBarControllerClass: String = "TabBarController"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
            let tabBarStoryboard = UIStoryboard(name: TabBarControllerClass, bundle: nil)
            let controller = tabBarStoryboard.instantiateViewController(identifier: TabBarControllerClass)
            guard let tabBarController = controller as? TabBarController
                else {
                    return
            }
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true, completion: nil)
    }
}

