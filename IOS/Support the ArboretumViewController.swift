//
//  Support the ArboretumViewController.swift
//  IOS
//
//  Created by Dhanekula,Dinesh Kumar on 6/23/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class Support_the_ArboretumViewController: UIViewController, ENSideMenuDelegate {

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
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
       // print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
       // print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
       // print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
