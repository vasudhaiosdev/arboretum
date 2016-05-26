//
//  ContactUs.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 7/9/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class ContactUs: UIViewController, ENSideMenuDelegate {
    var dimView:UIView!
    var ContactusInformationList:NSArray!
    
    
    //fetch the contact information from data and stored that information in contactusinformationlist array
    func dataOfJson(url: String)
    {
        let image=NSData(contentsOfURL: NSURL(string:url)!)
        ContactusInformationList=try!(NSJSONSerialization.JSONObjectWithData(image!, options:[])) as! NSArray
    }
    
    @IBOutlet weak var ContactusTextView: UITextView!
      override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        //Used to know if the device has internet connection or not.
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
            
            //(userInfo)
            
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
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
            
            
        case .Online(.WWAN):
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/link.php")
            for(var i:Int = 0 ; i < ContactusInformationList.count ; i++)
            {
                if("Information"==ContactusInformationList[i].valueForKey("name")as! String)
                {
                    ContactusTextView.text = (ContactusInformationList[i].valueForKey("information") as! String)
                                   }
            }
        case .Online(.WiFi):
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/link.php")
            
            for(var i:Int = 0 ; i < ContactusInformationList.count ; i++)
            {
                if("Information"==ContactusInformationList[i].valueForKey("name")as! String)
                {
                    ContactusTextView.text = (ContactusInformationList[i].valueForKey("information") as! String)
                }}}}
                    
            override func viewDidLoad() {
        super.viewDidLoad()
        hideSideMenuView()
         self.navigationItem.backBarButtonItem?.title = "Back"
    }

    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
  
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
   
}
