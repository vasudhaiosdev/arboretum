//
//  MyMenuTableTableViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 7/8/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController, UIImagePickerControllerDelegate {
    var selectedMenuItem : Int = 0
    var menuItems = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItems = ["Missouri Arboretum","Trails","Tree information", "Adopt a tree","Treevia","Information","Photos", "Facebook", "Northwest website"]
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
        
    
    }
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        //Used to find out whether the device has internet connection or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
            
           // print(userInfo)
            
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            //print("Not connected")
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet. This Application works only when internet is connected", preferredStyle: .Alert)
                                let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(settingsAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            
            
        case .Online(.WWAN): break
        case .Online(.WiFi): break
            
        }
        

    }
    
      override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            cell!.textLabel?.font = UIFont.boldSystemFontOfSize(16)
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        cell!.textLabel?.text = menuItems[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        selectedMenuItem = indexPath.row
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
           // vc = storyboard!.instantiateViewControllerWithIdentifier("HomeViewController")
            //
            //        self.navigationController?.pushViewController(vc, animated: true)
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HomeViewController")
           sideMenuController()?.setContentViewController(destViewController)
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Trails")
                //sideMenuController()?.setContentViewController(destViewController)
            sideMenuController()?.setContentViewController(destViewController)
                        break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TreeInfoViewController")
              sideMenuController()?.setContentViewController(destViewController)
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AdoptTree") 
              sideMenuController()?.setContentViewController(destViewController)
            break
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Treevia") 
              sideMenuController()?.setContentViewController(destViewController)
            break
            
        case 5:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Information") 
              sideMenuController()?.setContentViewController(destViewController)
            break
            
        case 6:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Photo_ViewController")
            sideMenuController()?.setContentViewController(destViewController)
            break
        
            
        case 7:
            if let url=NSURL(string: "https://www.facebook.com/MissouriArboretum")
            {
                UIApplication.sharedApplication().openURL(url)
            }
            
        default:
            if let url=NSURL(string: "http://www.nwmissouri.edu")
            {
                UIApplication.sharedApplication().openURL(url)
            }
          
        }
    
    }
    
    
}
