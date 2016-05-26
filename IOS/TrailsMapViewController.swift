//
//  TrailsMapViewController.swift
//  IOS
//
//  Created by Vasudha Jags on 10/11/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation



class TrailsMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var knowMapType: UISegmentedControl!
    @IBOutlet weak var viewMap: GMSMapView!
    var trailsMapArray: NSArray!
    var treeName:NSString!
    var trailMapPins: NSArray!
    var lattitude:CLLocationDegrees!
    var longitude:CLLocationDegrees!
    var tagValue:String!
    let locationManager = CLLocationManager()
    var didFindMyLocation = false
    var imgView:UIImageView!
    var actualImage:UIImage!
    var convertedImage:UIImage!
    var bearingView:UIImageView!
    var treeImage:NSArray!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
  
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func sideMenuWillOpen() {
    }
    
    func sideMenuWillClose() {
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        //Is used to check the internet connection
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
            
            //print(userInfo)
            
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
            parseJsonForTreeImage("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            
            parseJsonForImage("http://csgrad10.nwmissouri.edu/arboretum/trails.php")
            
            parseJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")

        case .Online(.WiFi):
            parseJsonForTreeImage("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            
            parseJsonForImage("http://csgrad10.nwmissouri.edu/arboretum/trails.php")
            
            parseJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            viewMap.myLocationEnabled = true
            // set the current location button
            
            viewMap.settings.myLocationButton = true
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        let heading = newHeading.magneticHeading
        let headingDegrees = (heading * (M_PI/180))
        self.bearingView.transform = CGAffineTransformMakeRotation(CGFloat(headingDegrees))
        viewMap.animateToBearing(headingDegrees)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            viewMap.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    func SquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return ResizeImage(SquareImage(image), targetSize: size)
    }
     
    func SquareImage(image: UIImage) -> UIImage {
        let originalWidth  = image.size.width
        let originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRectMake(posX, posY, edge, edge)
        
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func parseJsonForImage(url:String){
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        // var dataError:NSError?
        trailMapPins = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as!NSArray
        for i in trailMapPins {
            if(i.valueForKey("walkname") as! String == tagValue){
            let imagePath = i.valueForKey("flower")  as! String
            let image = NSData(contentsOfURL: NSURL(string: imagePath as String)!)
            actualImage = UIImage(data: image!)
            convertedImage = ResizeImage(actualImage, targetSize: CGSize(width: 20, height: 20))
            }
        }
        }
    
    //fetch the data from server and create the buttons based on the data availbale throught the server
    func parseJson(url: String){
        let data = NSData(contentsOfURL: NSURL(string: url)!)
       
        trailsMapArray = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSArray
        for i in appDelegate.TreeListArray{
            if(i.valueForKey("walkname") as! String == tagValue){
                let templattitude = i.valueForKey("latitude") as! NSString
                let templongitude = i.valueForKey("longitude") as! NSString
                let treeName = i.valueForKey("cname") as! NSString
                let treeId = i.valueForKey("treeid") as! NSString
                let treePreviewImage:UIImage = getTheTreeImage(treeId)
                lattitude = templattitude.doubleValue as CLLocationDegrees
                longitude = templongitude.doubleValue as CLLocationDegrees
                let location = CLLocationCoordinate2D(latitude: self.lattitude, longitude: self.longitude)
                let camera = GMSCameraPosition.cameraWithTarget(location, zoom: 16)
                viewMap.camera = camera
                let marker = GMSMarker()
                marker.position = location
                marker.title = treeName as String
                //marker.snippet = "(treeName as String)"
                marker.icon = convertedImage
                marker.flat = true
                marker.map = viewMap
                marker.userData = treePreviewImage
                
            }
        
        }
        
    }
    
    func getTheTreeImage(treeID: NSString) -> UIImage{
        var imagePath:String!
        for i in treeImage {
            if(treeID == i.valueForKey("treeid") as! NSString){
                imagePath = i.valueForKey("imageid") as! String
                
            }
            if(imagePath != nil){
                break
            }
        }
        if(imagePath != nil) {
            let image = NSData(contentsOfURL: NSURL(string: imagePath as String)!)
            return UIImage(data: image!)!
        }
        else {
            return UIImage(named: "watermarksmiley.jpg")!
        }
        
        
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        
         performSegueWithIdentifier("goToTreeInformation", sender:marker)
        
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        let view:customWindowInfo = NSBundle.mainBundle().loadNibNamed("InfoWindow", owner: self, options: nil)[0] as! customWindowInfo
        
        view.customImage.image = marker.userData as? UIImage
        view.treeName.text = marker.title
        return view
        
    }
    
    func buttonClicked(button: AnyObject) {
        //  println(button.tag)
        performSegueWithIdentifier("goToTreeInformation", sender:button)
    }
    
    
    
    
    
    @IBAction func mapTypeChanged(sender: AnyObject) {
        
        switch(knowMapType.selectedSegmentIndex){
        case 0: viewMap.mapType = GoogleMaps.kGMSTypeNormal
        case 1: viewMap.mapType = GoogleMaps.kGMSTypeSatellite
        default: viewMap.mapType = GoogleMaps.kGMSTypeHybrid
            
        }
    }
    
    func parseJsonForTreeImage(url:String){
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        // var dataError:NSError?
        treeImage = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as!NSArray
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSideMenuView()
           self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuWillClose")
        view.addGestureRecognizer(tap)
        viewMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // viewMap.settings.compassButton = true
        //  viewMap.settings.myLocationButton = true
        
      
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToTreeInformation"){
            let detailviewcontroller=segue.destinationViewController as! DetailtreeinfoViewController
            let typecasted = sender as! GMSMarker
            for d in appDelegate.TreeListArray {
                if(typecasted.title == d.valueForKey("cname") as? String){
                    detailviewcontroller.trailid = d.valueForKey("trailid") as! String
                    detailviewcontroller.cname = d.valueForKey("cname") as! String
                    detailviewcontroller.sname = d.valueForKey("sname") as! String
                    detailviewcontroller.descriptionoftree = d.valueForKey("description") as! String
                    detailviewcontroller.walkname = d.valueForKey("walkname") as! String
                    detailviewcontroller.tid = d.valueForKey("treeid")as! String
                }
 
            
        }
    }

}
}