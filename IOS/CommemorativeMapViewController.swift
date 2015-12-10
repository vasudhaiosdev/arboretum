//
//  CommemorativeMapViewController.swift
//  Arboretum
//
//  Created by Naresh kumar Nagulavancha on 12/8/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class CommemorativeMapViewController: UIViewController, ENSideMenuDelegate,GMSMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet var viewMap: GMSMapView!

    @IBOutlet var knowMapType: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var bearingView:UIImageView!
    var lattitude:NSString!
    var longitude:NSString!
    var actualImage:UIImage!
    var convertedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
           // parseJsonForTreeImage("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            
            
            parseJsonForImage("http://csgrad10.nwmissouri.edu//MissouriArboretum//images//Towertrailtreeicon.png")
            
           // parseJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
            
        case .Online(.WiFi):
            print("Connected via WiFi")
            //parseJsonForTreeImage("http://csgrad10.nwmissouri.edu/arboretum/images.php")
            
            
            parseJsonForImage("http://csgrad10.nwmissouri.edu//MissouriArboretum//images//Towertrailtreeicon.png")
            
          //  parseJson("http://csgrad10.nwmissouri.edu/arboretum/treetable.php")
            
            
        }
        

        
        
        
        
        
        
        
        
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuWillClose")
        view.addGestureRecognizer(tap)
        viewMap.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let tempLattitude = lattitude.doubleValue as CLLocationDegrees
        
        let tempLongitude = longitude.doubleValue as CLLocationDegrees

        let location = CLLocationCoordinate2D(latitude: tempLattitude, longitude: tempLongitude)
        let camera = GMSCameraPosition.cameraWithTarget(location, zoom: 16)
        viewMap.camera = camera
        let marker = GMSMarker()
        marker.position = location
        marker.flat = true
        marker.icon = convertedImage
        marker.map = viewMap
        let circleCenter = CLLocationCoordinate2DMake(tempLattitude, tempLongitude)
        let circ = GMSCircle(position: circleCenter, radius: 10)
        circ.fillColor = UIColor(red: 0, green: 51/255, blue: 0, alpha: 0.2)
        circ.strokeColor = UIColor(red: 0, green: 51/255, blue: 0, alpha: 1)
        circ.strokeWidth = 1
        circ.map = viewMap


        // Do any additional setup after loading the view.
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
                let imagePath = url
                let image = NSData(contentsOfURL: NSURL(string: imagePath as String)!)
                actualImage = UIImage(data: image!)
                convertedImage = ResizeImage(actualImage, targetSize: CGSize(width: 20, height: 20))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    func sideMenuWillOpen() {
        //print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        //print("sideMenuWillClose")
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
    }
    @IBAction func mapTypeChanged(sender: AnyObject) {
        
        switch(knowMapType.selectedSegmentIndex){
        case 0: viewMap.mapType = GoogleMaps.kGMSTypeNormal
        case 1: viewMap.mapType = GoogleMaps.kGMSTypeSatellite
        default: viewMap.mapType = GoogleMaps.kGMSTypeHybrid
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
