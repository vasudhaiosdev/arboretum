//
//  Photo_ViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 11/12/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit

class Photo_ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ENSideMenuDelegate
{
 
    @IBOutlet var itemimage: UIImageView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    @IBAction func Camera(sender: AnyObject)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        presentViewController(picker,animated: true,completion: nil)
        presentationController
        
    }
    @IBAction func Uploadphoto(sender: AnyObject)
    {
        let myPickerController=UIImagePickerController()
        myPickerController.delegate=self
        myPickerController.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        itemimage.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        unhideButton()
        
          self.dismissViewControllerAnimated(true, completion: nil)
      
    }
 
    
    @IBAction func SaveBtnTapped(sender: AnyObject) {
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
    func sideMenuShouldOpenSideMenu() -> Bool {
        //print("sideMenuShouldOpenSideMenu")
        return true
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
        case .Online(.WiFi):
            print("Connected via WiFi2")
            
        }
        

        
    }
   
    
    
    func myImageUploadRequest()
    {
        
    let myUrl = NSURL(string: "http://192.168.0.24/iosphotos/test.php");
       //let myUrl = NSURL(string: "http://172.20.10.10/iosphotos/test.php");
        
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
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            

            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                
                dispatch_async(dispatch_get_main_queue(),{
                   self.myActivityIndicator.stopAnimating()
                    
                    self.myActivityIndicator.hidden = true
                     self.hideButton()
                    self.itemimage.image = nil;
                });
                
                
                if let parseJSON = json {
                let firstNameValue = parseJSON["firstName"] as? String
                print("firstNameValue: \(firstNameValue)")
                }
                
                
            } catch{
                print(error)
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
    
    
    
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}


