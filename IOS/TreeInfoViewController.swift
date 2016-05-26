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
    
    //Used to get the json data and stored it in the treelistarray
    func dataOfJson(url: String) {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        TreeListArray = try!(NSJSONSerialization.JSONObjectWithData(data!, options:[]))as! NSArray
        
    }
    
    
    //Used to display the data treelistarray in table format
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TreeInfoCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TreeInfoCell
             let a : String = TreeListArray[indexPath.row].valueForKey("cname") as! String
        let b : String = TreeListArray[indexPath.row].valueForKey("walkname") as! String
        let c : String = TreeListArray[indexPath.row].valueForKey("trailid") as! String
        var b1 = b.componentsSeparatedByString(" ")
        let b2: String = b1[0]
        cell.setup(a, walkname: b2, trailid: c)
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBOutlet weak var TreeInfoTableView: UITableView!
   
    //Used to pass the data to see detail tree information in another view controler
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
         self.navigationItem.backBarButtonItem?.title = "Back"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
       
        //Used to find out if the device has internet connection or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            NoInternet="NONET"
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
                dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
        case .Online(.WiFi):
              dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
            
            
        }
        

    }
   
}
