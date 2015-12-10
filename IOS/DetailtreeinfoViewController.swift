//
//  DetailtreeinfoViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 6/29/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit



class DetailtreeinfoViewController: UIViewController, UIPageViewControllerDataSource, ENSideMenuDelegate, UIPageViewControllerDelegate{
    
    
    @IBOutlet var scrol: UIScrollView!
    
    
    
    
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
    
    
    func dataOfJson(url: String)
    {
        
        let image=NSData(contentsOfURL: NSURL(string:url)!)
        
        Treeimagelist=try!(NSJSONSerialization.JSONObjectWithData(image!, options:[]))as! NSArray
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
         self.navigationItem.backBarButtonItem?.title = "Back"
        
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
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            function()
        case .Online(.WiFi):
            print("Connected via WiFi2")
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            function()
            
        }
        

    }
    
    override func viewDidLoad()
        
    {
        
        //scrol.alwaysBounceHorizontal = false
        //scrol.directionalLockEnabled = true
         self.navigationItem.backBarButtonItem?.title = "Back"
        super.viewDidLoad()
        treedes.text = ""
        treeid.text = ""
        treetrail.text = ""
        scientificname.text = ""
        commonname.text = ""
        
        
        
              //  animationArray.append(ISVC.imageView.image!)
        
        // Do any additional setup after loading the view.
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
            let path:String = NSBundle.mainBundle().pathForResource("watermarksmiley", ofType: "jpg")!
            imageurl.append(path)
        }
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        let startVC = self.ImageScroll(0) as ImageScrollViewController
        let viewControllersArray = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllersArray as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        
        
        
        self.MyImageView?.addSubview(self.pageViewController.view)
       // self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        //self.MyImageView?.frame=self.pageViewController.view.frame
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func ImageScroll(index: Int) -> ImageScrollViewController
    {
        ISVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageScrollViewController") as! ImageScrollViewController
        

        
        
        ISVC.imageFile = self.imageurl[index] as String
        ISVC.pageIndex = index
        
//        ISVC.imageView.animationImages = animationArray
//        ISVC.imageView.animationDuration = 5
//        ISVC.imageView.startAnimating()
        
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
        
        //ISVC.
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
        print(currentIndex)
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
        print("printing Current page \(currentIndex)")
    }
    override func viewWillDisappear(animated: Bool) {
        if(imageurl.count<1){
            
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
                timer.invalidate()
            case .Online(.WiFi):
                print("Connected via WiFi2")
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
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
       // print("sideMenuWillOpen")
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
