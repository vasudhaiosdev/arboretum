//
//  Support the ArboretumViewController.swift
//  IOS
//
//  Created by Dhanekula,Dinesh Kumar on 6/23/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class Support_the_ArboretumViewController: UIViewController, ENSideMenuDelegate {

   //Used to fetch the data from database and display that data.
    @IBAction func how_to_adopt_a_tree(sender: AnyObject)
    {
        if let url=NSURL(string: "http://www.nwmissouri.edu/arboretum/application.htm")
        {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  }
