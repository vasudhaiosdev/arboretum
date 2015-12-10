//
//  TreeInfoViewController.swift
//  IOS
//
//  Created by admin on 6/24/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class TreeInfoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, ENSideMenuDelegate {
    
    @IBOutlet var CommonNameLBL: UILabel!
    
    @IBOutlet var TrailIDLBL: UILabel!
    @IBOutlet var TrailNameLBL: UILabel!
    var NoInternet:String = ""
    var TreeListArray:NSArray!
    @IBOutlet weak var menu: UIBarButtonItem!
//    @IBAction func back(sender: AnyObject)
//    {
//        var vc:UIViewController!
//        vc = storyboard!.instantiateViewControllerWithIdentifier("HomeViewController")
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//               }
   
    
    func dataOfJson(url: String) {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        
        TreeListArray = try!(NSJSONSerialization.JSONObjectWithData(data!, options:[]))as! NSArray
        
       
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TreeInfoCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TreeInfoCell
        
   //  var detailsObj: Details = TreeListArray[indexPath.row] as! Details
       // var detailsObj:Details!
        
        let a : String = TreeListArray[indexPath.row].valueForKey("cname") as! String
        let b : String = TreeListArray[indexPath.row].valueForKey("walkname") as! String
        let c : String = TreeListArray[indexPath.row].valueForKey("trailid") as! String
      
        
        
        var b1 = b.componentsSeparatedByString(" ")
        
        let b2: String = b1[0]
        
   //     cell.setup(TreeListArray[indexPath.row].valueForKey("cname"), walkname: TreeListArray[indexPath.row].valueForKey("walkname"), trailid: TreeListArray[indexPath.row].valueForKey("trailid"))
        
        cell.setup(a, walkname: b2, trailid: c)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println(TreeListArray.count)
        
        if NoInternet=="NONET"
        {
            return 0
        }
        else
        {
        
        return TreeListArray.count
        }
        
    }
    
    
    override func viewDidLoad() {
        
        
        
         self.navigationItem.backBarButtonItem?.title = "Back"
    
        super.viewDidLoad()
        hideSideMenuView()
                
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var TreeInfoTableView: UITableView!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailviewcontroller=segue.destinationViewController as! DetailtreeinfoViewController
        if(segue.identifier=="detail")
        {
            let indexPath = self.TreeInfoTableView.indexPathForSelectedRow
           
            let row=indexPath?.row
            detailviewcontroller.trailid=TreeListArray[row!].valueForKey("trailid") as! String
            detailviewcontroller.cname=TreeListArray[row!].valueForKey("cname") as! String
            detailviewcontroller.sname=TreeListArray[row!].valueForKey("sname") as! String
            detailviewcontroller.descriptionoftree=TreeListArray[row!].valueForKey("description") as! String
            detailviewcontroller.walkname=TreeListArray[row!].valueForKey("walkname") as! String
detailviewcontroller.tid=TreeListArray[row!].valueForKey("treeid")as! String
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item

        }
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
      //  print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
      //  print("sideMenuWillClose")
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
            NoInternet="NONET"
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
                dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
        case .Online(.WiFi):
            print("Connected via WiFi2")
              dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
            
            
        }
        

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
