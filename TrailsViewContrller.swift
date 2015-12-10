//
//  TrailsViewContrller.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 10/11/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit


class TrailsViewContrller: UIViewController, ENSideMenuDelegate {
    
    var DonorsArray:NSArray!
    var trailName:NSString = ""
    var imagePath:NSString = ""
    var countTag:Int = 0
    var trailNames  = [String]()
//    
//    @IBAction func back(sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func sideMenuWillOpen() {
     //   print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
       // print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        //print("sideMenuShouldOpenSideMenu")
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
         //self.navigationItem.backBarButtonItem?.title = "Back"
        // self.navigationItem.title = "Trails"
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        
        
        
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
         
            
            
        case .Online(.WWAN):
            print("Connected via WWAN")
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/trails.php")

        case .Online(.WiFi):
            print("Connected via WiFi")
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/trails.php")

            
        }


    }
    func dataOfJson(url :String)
    {   //var labelX :CGFloat = 30
        let labelY:CGFloat = 180
        let imageX:CGFloat = 25
        let imageY:CGFloat = 75
        var count:Int = 1
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        // let dataError: NSError?
        DonorsArray = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSArray
        for i in DonorsArray{
            
            
            trailName = i.valueForKey("walkname") as! String
            imagePath = i.valueForKey("image")  as! String
            
            let image = NSData(contentsOfURL: NSURL(string: imagePath as String)!)
            
            let imageButton:UIButton = UIButton(type: UIButtonType.Custom)
            imageButton.frame = CGRectMake(imageX, imageY, 75, 75)
            let actualImage:UIImage = UIImage(data: image!)!
            imageButton.backgroundColor = UIColor.whiteColor()
            imageButton.layer.cornerRadius = 8.0
            imageButton.setImage(actualImage, forState: UIControlState.Normal)
            //imageButton.userInteractionEnabled = true
            // imageButton.clipsToBounds = true
            imageButton.tag = countTag
            trailNames.append(trailName as String)
            imageButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let label = UILabel(frame: CGRectMake(imageX , labelY, 100, 200))
            label.text = trailName as String
            label.numberOfLines = 0
            label.sizeToFit()
            label.textAlignment = .Center
            label.font = UIFont(name:"Helvetica-Bold" , size: 13)
            
            
//            if(imageX == 275){
//                imageY = imageY+160
//                labelY = imageY+100
//                imageX = 25
//            }
//            else{
//                imageX = imageX+125}
            countTag++

            
            label.translatesAutoresizingMaskIntoConstraints = false
            imageButton.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(label)
            self.view.addSubview(imageButton)
            
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80))
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 85))
            
            var tempMultiplier:Int = 0
            
            if(count%3 == 1){
                
            tempMultiplier = 1+(count-1)/3
                let tempCGFloat:CGFloat = CGFloat(tempMultiplier)
                
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: tempCGFloat, constant: tempCGFloat*140))
                
                view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
                
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 1))
                
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20))
            }
            
            if(count%3 == 2){
                tempMultiplier = 1+(count-1)/3
                let tempCGFloat:CGFloat = CGFloat(tempMultiplier)
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.CenterX, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: tempCGFloat, constant: tempCGFloat*140))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 1))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
                
            }
            
            if(count%3 == 0){
                
                
                tempMultiplier = 1+(count-1)/3
                let tempCGFloat:CGFloat = CGFloat(tempMultiplier)
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20))
            view.addConstraint(NSLayoutConstraint(item: imageButton, attribute: .Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: tempCGFloat, constant: tempCGFloat*140))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: imageButton, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 1))
            view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20))
            }
            
            count = count+1
        }
    }
    
    
    func buttonClicked(button: AnyObject) {
        performSegueWithIdentifier("gg", sender:button)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gg"){
            let svc:TrailsMapViewController = segue.destinationViewController as! TrailsMapViewController
            svc.tagValue = trailNames[(sender?.tag)!]
            print(trailNames[(sender?.tag)!])
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
            
            
            //  self.navigationController?.title = "Back"
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
              
//        if Reachability.isConnectedToNetwork() == false {
//            print("Internet connection Failed")
//            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
//            
//        } else {
//            print("Internet connection OK")
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item

             self.navigationItem.title = "Trails"
        
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tanbackground.png")!)
            // view.backgroundColor = UIColor.orangeColor()
        
            hideSideMenuView()
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuWillClose")
            view.addGestureRecognizer(tap)

            
        //}

        
                 // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    



}
