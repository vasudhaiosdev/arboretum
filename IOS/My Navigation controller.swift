//
//  My Navigation controller.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 7/8/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class My_Navigation_controller: ENSideMenuNavigationController, ENSideMenuDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MyMenuTableViewController(), menuPosition:.Right)
        sideMenu?.menuWidth = 200.0
        view.bringSubviewToFront(navigationBar)
    }

}
