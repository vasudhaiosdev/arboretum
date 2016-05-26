//
//  DetailtreeinfoViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 6/29/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit



class DetailtreeinfoViewController: UIViewController, UIPageViewControllerDataSource, ENSideMenuDelegate, UIPageViewControllerDelegate{
    var pageViewController: UIPageViewController!
    var imageurl=[String]()
    var count:Int=0;
    var animationArray: [UIImage]!
    
    @IBOutlet weak var treedes: UITextView!
    @IBOutlet weak var treeid: UILabel!
    @IBOutlet weak var treetrail: UILabel!
    @IBOutlet weak var commonname: UILabel!
    @IBOutlet weak var scientificname: UILabel!
    
    var pageImages: NSArray!
    var ISVC: ImageScrollViewController!
    var timer:NSTimer!
    var trailid:String = ""
    var cname:String=""
    var sname:String=""
    var descriptionoftree:String=""
    var walkname:String=""
    var tid:String=""
    var Treeimagelist:NSArray!
    var currentIndex:Int = 0
    
    //get the data from json and stored it into the treeimagelist array
    func dataOfJson(url: String)
    {
        
        let image=NSData(contentsOfURL: NSURL(string:url)!)
        
        Treeimagelist=try!(NSJSONSerialization.JSONObjectWithData(image!, options:[]))as! NSArray
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
         self.navigationItem.backBarButtonItem?.title = "Back"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)

        //Used to find out whether the device is connected to internt or not
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
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            function()
        case .Online(.WiFi):
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            function()
            
        }
        

    }
    
    override func viewDidLoad()
        
    {    self.navigationItem.backBarButtonItem?.title = "Back"
        super.viewDidLoad()
        treedes.text = ""
        treeid.text = ""
        treetrail.text = ""
        scientificname.text = ""
        commonname.text = ""
       }
    
    @IBOutlet var MyImageView: UIView?
    
    func function()
    {
        treedes.editable=false
        treedes.text=descriptionoftree
        treetrail.text=walkname
        treeid.text=trailid
        scientificname.text=sname
        commonname.text=cname
        for(var i:Int = 0 ; i < Treeimagelist.count ; i++)
        {
            if(tid==Treeimagelist[i].valueForKey("treeid")as! String)
            {
                if(count<6)
                {
                    imageurl.append(Treeimagelist[i].valueForKey("imageid") as! String)
                    
                }
                count++
            }
        }
        if(imageurl.count == 0){
            let path:String = NSBundle.mainBundle().pathForResource("notAvailable", ofType: "png")!
            imageurl.append(path)
        }
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        let startVC = self.ImageScroll(0) as ImageScrollViewController
        let viewControllersArray = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllersArray as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.MyImageView?.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
            self.pageViewController.view.frame = self.MyImageView!.frame
        self.pageViewController.view.frame = CGRectMake(0, 0, self.MyImageView!.frame.width, self.MyImageView!.frame.height)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuWillClose")
        view.addGestureRecognizer(tap)
        if(imageurl.count > 1)
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "loadNextController", userInfo: nil, repeats: true)
        }

    }
    
    func menuWillClose(){
    hideSideMenuView()
    }
    
    func ImageScroll(index: Int) -> ImageScrollViewController
    {
        ISVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageScrollViewController") as! ImageScrollViewController
        

        
        
        ISVC.imageFile = self.imageurl[index] as String
        ISVC.pageIndex = index
        return ISVC
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let ISVC = viewController as! ImageScrollViewController
        var index = ISVC.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        index--
        return self.ImageScroll(index)
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.imageurl.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    
    func loadNextController() {
        currentIndex = currentIndex + 1
        if(currentIndex >= imageurl.count){
            currentIndex = 0
        }
        let startVC = self.ImageScroll(currentIndex) as ImageScrollViewController
        let viewControllersArray = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllersArray as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let subViews: Array = self.pageViewController.view.subviews
        var pageControle:UIPageControl! = nil
        for(var i = 0; i<subViews.count; i++)
        {
            if (subViews[i] is UIPageControl){
                pageControle = subViews[i] as! UIPageControl
                break
            }
        }
        currentIndex = pageControle.currentPage
    }
    
    override func viewWillDisappear(animated: Bool) {
        if(imageurl.count<1){
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
            func networkStatusChanged(notification: NSNotification) {
                _ = notification.userInfo
            }
            let status = Reach().connectionStatus()
            switch status {
            case .Unknown, .Offline:
               // print("Not connected")
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
                timer.invalidate()
            case .Online(.WiFi):
                timer.invalidate()
                
            }
            
            
            
            
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let ISVC = viewController as! ImageScrollViewController
        var index = ISVC.pageIndex as Int
        
        if(index == NSNotFound)
        {
            return nil
        }
        
        index++
        
        if(index == self.imageurl.count)
        {
            return nil
        }
        
        return self.ImageScroll(index)
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    
}
