//
//  GameTabBarController.swift
//  TestGames
//
//  Created by Harsha on 09/07/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class GameTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let svc = viewController as? SetGameViewController {
            svc.resetGame()
        } else if let svc = viewController as? ConcentrationViewController {
            svc.resetGame()
        }
    }
}
