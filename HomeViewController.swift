//
//  HomeViewController.swift
//  IOS
//
//  Created by Dhanekula,Dinesh Kumar on 6/23/15.
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
        }
        
    }

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
        //Reach().monitorReachabilityChanges()
        
        
        func networkStatusChanged(notification: NSNotification) {
            let userInfo = notification.userInfo
            
            print(userInfo)
            
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            print("Not connected")
//            dispatch_async(dispatch_get_main_queue(), {
//                let alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet. This Application works only when internet is connected", preferredStyle: .Alert)
//                
//                
//                //  let cancelAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
//                
//                let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
//                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
//                    if let url = settingsUrl {
//                        UIApplication.sharedApplication().openURL(url)
//                    }
//                }
//                // alertController.addAction(cancelAction)
//                
//                alertController.addAction(settingsAction)
//                
//                self.presentViewController(alertController, animated: true, completion: nil)
//            })
//            
            
        case .Online(.WWAN):
            print("Connected via WWAN")
        case .Online(.WiFi):
            print("Connected via WiFi2")
            
        }
        
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
            //self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
            
            
            // Do any additional setup after loading the view.
            
            
       // }

    
        
        
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
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        
        
      //  print("sideMenuWillOpen")
        //flag = true
    }
    
    func sideMenuWillClose() {
       // brightDisplay()
        //flag = false
        //print("sideMenuWillClose")
    }
    
//    func dimDisplay(){
//        
//        self.dimView = UIView(frame: CGRect(x: 160, y: 0, width: 160, height: 568))
//        self.dimView.backgroundColor = UIColor.blackColor()
//        self.dimView.alpha = 0
//        view.addSubview(self.dimView)
//        view.bringSubviewToFront(self.dimView)
//        UIView.animateWithDuration(0.3, delay: 0.5, options: nil, animations: {{self.dimView.alpha = 0.3}}, completion: nil)
//        //UIView.animateWithDuration(0.3, animations: )
//        
//    }
    
//    func brightDisplay(){
//        
//        UIView.animateWithDuration(0.3, animations: {self.vc.view.alpha = 0})
//        
//    }
    func sideMenuShouldOpenSideMenu() -> Bool {
      //  print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    @IBAction func cancelHomeViewController(segue:UIStoryboardSegue){
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
