//
//  CommemorativeMapViewController.swift
//  Arboretum
//
//  Created by Naresh kumar Nagulavancha on 12/8/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit
import GoogleMaps


class CommemorativeMapViewController: UIViewController, ENSideMenuDelegate,GMSMapViewDelegate {
   
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
        
                //Used to find if the net is connected to the device or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            print("Not connected")
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
                     parseJsonForImage("http://csgrad10.nwmissouri.edu//MissouriArboretum//images//Towertrailtreeicon.png")
          
            
        case .Online(.WiFi):
                     parseJsonForImage("http://csgrad10.nwmissouri.edu//MissouriArboretum//images//Towertrailtreeicon.png")
                 }
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("menuWillClose"))
        view.addGestureRecognizer(tap)
        viewMap.delegate = self
        let tempLattitude = lattitude.doubleValue as CLLocationDegrees
        let tempLongitude = longitude.doubleValue as CLLocationDegrees
        let location = CLLocationCoordinate2D(latitude: tempLattitude, longitude: tempLongitude)
        let camera = GMSCameraPosition.cameraWithTarget(location, zoom: 20)
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
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
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
 }
