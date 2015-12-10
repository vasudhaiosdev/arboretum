//
//  TreeviaquestionsViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 6/30/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class TreeviaquestionsViewController: UIViewController, ENSideMenuDelegate {

    
    var question: String!
    var answer: String!
    var randomQn: Int!
    var TreeviaArray : NSArray = []
    
//    @IBAction func back(sender: AnyObject)
//    {
//        var vc:UIViewController!
//        vc = storyboard!.instantiateViewControllerWithIdentifier("HomeViewController")
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
//    
    
    override func viewDidLoad() {
        
    
        questionLBL.text = ""
        answerLBL.text = ""
        super.viewDidLoad()
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item

        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "menuWillClose")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func menuWillClose(){
    hideSideMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var questionLBL1: UIButton!
    @IBOutlet var answerLBL1: UIButton!
    @IBOutlet weak var answerLBL: UITextView!
    @IBOutlet weak var questionLBL: UITextView!
    
    @IBAction func AnswerBTN(sender: AnyObject) {
        
        answer = TreeviaArray[randomQn].valueForKey("answer") as! String
        answerLBL.text = answer
        hideSideMenuView()
    }
    
    @IBAction func QuestionBTN(sender: AnyObject) {
        
        randomQnGenerator()
        answerLBL.text = ""
        hideSideMenuView()
    }
    
    func randomQnGenerator()
    {
        randomQn = Int(arc4random_uniform(UInt32(TreeviaArray.count)))
        question = TreeviaArray[randomQn].valueForKey("question")as! String;()
        questionLBL.text = question
        questionLBL.font = UIFont.boldSystemFontOfSize(13.0)
    }
    
    func dataOfJson(url: String) {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        TreeviaArray = try!(NSJSONSerialization.JSONObjectWithData(data!, options:[]))as! NSArray
    }
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
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
                self.answerLBL1.enabled = false
                self.questionLBL1.enabled = false
            })
            
            
        case .Online(.WWAN):
            print("Connected via WWAN")
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treevia.php")
            randomQnGenerator()
        case .Online(.WiFi):
            print("Connected via WiFi2")
             dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treevia.php")
            randomQnGenerator()
            
        }
        


    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
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
      //  print("sideMenuShouldOpenSideMenu")
        return true
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
