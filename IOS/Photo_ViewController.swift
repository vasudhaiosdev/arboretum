//
//  Photo_ViewController.swift
//  IOS
//
//  Created by Vasudha Jags on 11/12/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit

class Photo_ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ENSideMenuDelegate
{
 
    @IBOutlet var itemimage: UIImageView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
   
    //Used to take the photo
    @IBAction func Camera(sender: AnyObject)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        presentViewController(picker,animated: true,completion: nil)
        presentationController
        
    }
    
    //Used to browse the photo form photo libreary
    @IBAction func Uploadphoto(sender: AnyObject)
    {
        let myPickerController=UIImagePickerController()
        myPickerController.delegate=self
        myPickerController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    //Used to reduce the image size
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
    
    //Used to assign the image to itemimage
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {

        itemimage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        unhideButton()

          self.dismissViewControllerAnimated(true, completion: nil)
    }
 

    @IBAction func SaveBtnTapped(sender: AnyObject)
    {
        itemimage.image =     self.ResizeImage(itemimage.image!, targetSize: CGSizeMake(1000.0, 1300.0))
        myImageUploadRequest()
        
    }
   
    @IBOutlet var saveBTN: UIButton!

    override func viewDidLoad()
    {
         self.navigationItem.backBarButtonItem?.title = "Back"
        hideButton()
        self.myActivityIndicator.hidden = true
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
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
    func hideButton()
    {
        self.saveBTN.hidden = true
    }
    
    func unhideButton()
    {
        self.saveBTN.hidden = false
    }
    override func viewWillAppear(animated: Bool)
    {
        hideSideMenuView()
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        
        //Used to check if the device has internet connection on not
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
        case .Online(.WWAN): break
        case .Online(.WiFi): break
            
        }
    }
   
    
    //Functions those are used to upload the images through server
    func myImageUploadRequest()
    {
        
    let myUrl = NSURL(string: "http://csgrad10.nwmissouri.edu/MissouriArboretum/iosUploadPhp.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "firstName"  : "Hareesh",
            "lastName"    : "Thirunahari",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
    
        let imageData = UIImageJPEGRepresentation(itemimage.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
    
        self.myActivityIndicator.hidden = false
       self.myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                return
            }
_ = NSString(data: data!, encoding: NSUTF8StringEncoding)
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                
                dispatch_async(dispatch_get_main_queue(),{
                   self.myActivityIndicator.stopAnimating()
                    
                    self.myActivityIndicator.hidden = true
                     self.hideButton()
                    self.itemimage.image = nil;
                });
                
                
                if let parseJSON = json {
                _ = parseJSON["firstName"] as? String
                }
                
                
            } catch{
            }
            
            if (error == nil)
            {
                let alertController1 = UIAlertController (title: "Success!", message: "The image you selected has been uploaded.", preferredStyle: .Alert)
                
                
                  let cancelAction1 = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                
                    alertController1.addAction(cancelAction1)
                
                self.presentViewController(alertController1, animated: true, completion: nil)

            }
            else
            {
                let alertController2 = UIAlertController (title: "Failure!", message: "The image you selected has NOT been uploaded. Please try again.", preferredStyle: .Alert)
                
                
                let cancelAction2 = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                
                alertController2.addAction(cancelAction2)
                
                self.presentViewController(alertController2, animated: true, completion: nil)
            }
            
        }
        
        task.resume()
        
        
        
    }
    
    var filename = "image"
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        

        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
       
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "browseImages"){
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
    }
    
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}


