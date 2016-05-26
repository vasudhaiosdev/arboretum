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

    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
   
    func menuWillClose(){
        hideSideMenuView()
    }
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        //Used to find if the net is connected to the device or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
             }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            let alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet. This Application works only when internet is connected", preferredStyle: .Alert)
                 let settingsAction = UIAlertAction(title: "Settings", style: .Default) { (_) -> Void in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(settingsAction)
                self.presentViewController(alertController, animated: true, completion: nil)
              case .Online(.WWAN):
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/trails.php")
        case .Online(.WiFi):
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/trails.php")
        }

    }
    
    func dataOfJson(url :String)
    {
        let labelY:CGFloat = 180
        let imageX:CGFloat = 25
        let imageY:CGFloat = 75
        var count:Int = 1
        let data = NSData(contentsOfURL: NSURL(string: url)!)
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
            imageButton.tag = countTag
            trailNames.append(trailName as String)
            imageButton.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let label = UILabel(frame: CGRectMake(imageX , labelY, 100, 200))
            label.text = trailName as String
            label.numberOfLines = 0
            label.sizeToFit()
            label.textAlignment = .Center
            label.font = UIFont(name:"Helvetica-Bold" , size: 13)
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
    
    //Is used to naviagte to the maps
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "gg"){
            let svc:TrailsMapViewController = segue.destinationViewController as! TrailsMapViewController
            svc.tagValue = trailNames[(sender?.tag)!]
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
             self.navigationItem.title = "Trails"
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tanbackground.png")!)
                  hideSideMenuView()
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuWillClose")
            view.addGestureRecognizer(tap)

    }
 }
