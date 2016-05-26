//
//  Dontation.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 7/20/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class Dontation: UIViewController {
    var dimView:UIView!
    var DonationInformationList:NSArray!
   
    // Function that is used to add josn data to an array named DonationInformationlist
    func dataOfJson(url: String)
    {
        let image=NSData(contentsOfURL: NSURL(string:url)!)
        DonationInformationList=try!(NSJSONSerialization.JSONObjectWithData(image!, options:[])) as! NSArray
    }
    
    
    
    @IBOutlet weak var DonationTextView: UITextView!
   
    @IBAction func back(sender: AnyObject)
    {
        var vc:UIViewController!
        vc = storyboard!.instantiateViewControllerWithIdentifier("SupportArboretum")
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
      //Used to find out if the device is connected to internet or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
            
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
            
            for(var i:Int = 0 ; i < DonationInformationList.count ; i++)
            {
                if("Donations"==DonationInformationList[i].valueForKey("name")as! String)
                {
                    DonationTextView.text = (DonationInformationList[i].valueForKey("information") as! String)
                    //DonationTextView.backgroundColor
                    
                }
            }
            

        case .Online(.WiFi):
            //print("Connected via WiFi2")
               dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/link.php")
            
            for(var i:Int = 0 ; i < DonationInformationList.count ; i++)
            {
                if("Donations"==DonationInformationList[i].valueForKey("name")as! String)
                {
                    DonationTextView.text = (DonationInformationList[i].valueForKey("information") as! String)
                    
                }}}

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.backBarButtonItem?.title = "Back"
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
   }
