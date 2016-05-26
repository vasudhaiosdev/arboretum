//
//  CollectionViewController.swift
//  IOS
//
//  Created by Vasudha Jags on 11/15/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
  
    @IBOutlet var collectionview: UICollectionView!

    var Treeimagelist:NSArray!
    
    //Function that is used to add josn data to an array named Treeimagelist.
    func dataOfJson(url:String)
    {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        Treeimagelist = try!(NSJSONSerialization.JSONObjectWithData(data!, options:[]))as! NSArray
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        //Used to find if the net is connected to the device or not
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
                dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treeimages.php")
        case .Online(.WiFi):
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treeimages.php")
            
        }
        print(Treeimagelist)

    }

    
//Funtion used to display images in collection view
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Treeimagelist.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let a:String = "\(Treeimagelist[indexPath.item].valueForKey("location") as! String)/\(Treeimagelist[indexPath.item].valueForKey("imageid") as! String)"
            cell.getphoto(a)
        return cell
}
    
    
    //Used to view the image in a saparate viewcontroler
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailviewcontroller=segue.destinationViewController as! deatilimageViewController
        if(segue.identifier=="detail")
        {
            let cell = sender as? UICollectionViewCell
            let indexPath = self.collectionview.indexPathForCell(cell!)
        detailviewcontroller.ind="\(Treeimagelist[indexPath!.item].valueForKey("location") as! String)/\(Treeimagelist[indexPath!.item].valueForKey("imageid") as! String)"

        }
    }
}
