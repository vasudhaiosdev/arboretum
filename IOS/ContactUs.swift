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
    
    
    
    func dataOfJson(url: String)
    {
        
        let image=NSData(contentsOfURL: NSURL(string:url)!)
        //var dataError: NSError?
        ContactusInformationList=try!(NSJSONSerialization.JSONObjectWithData(image!, options:[])) as! NSArray
    }
    
    @IBOutlet weak var ContactusTextView: UITextView!
    
    
    

    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        //Reach().monitorReachabilityChanges()
        
        
        func networkStatusChanged(notification: NSNotification) {
            let userInfo = notification.userInfo
            
            print(userInfo)
            
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            print("Not connected")
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet. This Application works only when internet is connected", preferredStyle: .Alert)
                
                
                //  let cancelAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                // alertController.addAction(cancelAction)
                
                alertController.addAction(settingsAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            })
            
            
        case .Online(.WWAN):
            print("Connected via WWAN")
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/link.php")
            
            for(var i:Int = 0 ; i < ContactusInformationList.count ; i++)
            {
                if("Information"==ContactusInformationList[i].valueForKey("name")as! String)
                {
                    ContactusTextView.text = (ContactusInformationList[i].valueForKey("information") as! String)
                    //DonationTextView.backgroundColor
                    
                }
            }
        case .Online(.WiFi):
            print("Connected via WiFi2")
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/link.php")
            
            for(var i:Int = 0 ; i < ContactusInformationList.count ; i++)
            {
                if("Information"==ContactusInformationList[i].valueForKey("name")as! String)
                {
                    ContactusTextView.text = (ContactusInformationList[i].valueForKey("information") as! String)
                    //DonationTextView.backgroundColor
                    
                }
            }
            
        }
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSideMenuView()
         self.navigationItem.backBarButtonItem?.title = "Back"
        
        
        
       

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
      //  print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
       // print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
      //  print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
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
