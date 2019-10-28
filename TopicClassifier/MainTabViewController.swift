//
//  MainTabViewController.swift
//  TopicClassifier
//
//  Created by M'haimdat omar on 26-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        if #available(iOS 13.0, *) {
           tabBar.backgroundColor = UIColor.label
        } else {
           // Fallback on earlier versions
           tabBar.backgroundColor = UIColor.black
        }
        tabBar.isTranslucent = true
    }
    
    func setupTabBar() {
        
        let vc = ViewController()
        
        let viewController = UINavigationController(rootViewController: vc)
        viewController.tabBarItem.image = UIImage(systemName: "text.badge.plus")?.withTintColor(.white)
        viewController.tabBarItem.title = "News"
        
        viewControllers = [viewController]
        
        UITabBar.appearance().tintColor = .label
        let navigation = UINavigationBar.appearance()
        
        let navigationFont = UIFont(name: "Avenir", size: 20)
        let navigationLargeFont = UIFont(name: "Avenir-Heavy", size: 34)
        
        navigation.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationFont!]
        
        if #available(iOS 11, *) {
            navigation.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationLargeFont!]
        }
    }
}
