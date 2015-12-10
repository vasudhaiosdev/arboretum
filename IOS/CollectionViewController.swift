//
//  CollectionViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 11/15/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit


//private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
   var Treeimagelist:NSArray!
    //var imagePath:NSArray

    override func viewDidLoad()
    {
        super.viewDidLoad()
       
     

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
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
        case .Online(.WiFi):
            print("Connected via WiFi2")
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            
        }
        

    }
    func dataOfJson(url:String)
    {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        Treeimagelist=try!(NSJSONSerialization.JSONObjectWithData(data!, options:[]))as! NSArray
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Treeimagelist.count   }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        
        //let a:String = Treeimagelist[indexPath.item].valueForKey(<#T##key: String##String#>)
        let a:String = Treeimagelist[indexPath.item].valueForKey("imageid") as! String

        cell.getphoto(a)
        return cell
    }
    @IBOutlet var collectionview: UICollectionView!
   // @IBOutlet var collectionview: UIScrollView!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailviewcontroller=segue.destinationViewController as! deatilimageViewController
        if(segue.identifier=="detail")
        {
            let cell = sender as? UICollectionViewCell
            let indexPath = self.collectionview.indexPathForCell(cell!)
            
            //let item=indexPath.item

        detailviewcontroller.ind=Treeimagelist[(indexPath?.item)!].valueForKey("imageid") as! String
//            detailviewcontroller.trailid=TreeListArray[row!].valueForKey("trailid") as! String
//            detailviewcontroller.cname=TreeListArray[row!].valueForKey("cname") as! String
//            detailviewcontroller.sname=TreeListArray[row!].valueForKey("sname") as! String
//            detailviewcontroller.descriptionoftree=TreeListArray[row!].valueForKey("description") as! String
//            detailviewcontroller.walkname=TreeListArray[row!].valueForKey("walkname") as! String
//            detailviewcontroller.tid=TreeListArray[row!].valueForKey("treeid")as! String
//            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            //self.navigationItem.backBarButtonItem = item
            
        }
    }

        // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
