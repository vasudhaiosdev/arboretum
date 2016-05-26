//
//  HomeViewController.swift
//  IOS
//
//  Created by Vasudha Jags on 6/23/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, ENSideMenuDelegate
{
    var dimView: UIView!
    var flag:Bool = false
    var vc:UIViewController!
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    
    
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBAction func Arboretumnwmissouri(sender: AnyObject)
    {
        if let url=NSURL(string: "http://www.nwmissouri.edu/arboretum")
        {
            UIApplication.sharedApplication().openURL(url)
        }}
    @IBAction func Facebookpage(sender: AnyObject)
    {
        if let url=NSURL(string: "https://www.facebook.com/MissouriArboretum")
        {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    @IBAction func Northwestsite(sender: AnyObject)
    {
        if let url=NSURL(string: "http://www.nwmissouri.edu")
        {
            UIApplication.sharedApplication().openURL(url)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
              self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tanbackground.png")!)
            self.sideMenuController()?.sideMenu?.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "trails"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
        if(segue.identifier == "information"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
        if(segue.identifier == "treevia"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
        if(segue.identifier == "treeinfo"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
        if(segue.identifier == "adoptTree"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
        if(segue.identifier == "photos"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item}
    }
    
}
