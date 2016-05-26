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
 
    override func viewDidLoad() {
        questionLBL.text = ""
        answerLBL.text = ""
        super.viewDidLoad()
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TreeviaquestionsViewController.menuWillClose))
        view.addGestureRecognizer(tap)
      }
    
    func menuWillClose(){
    hideSideMenuView()
    }
    
    @IBOutlet var questionLBL1: UIButton!
    @IBOutlet var answerLBL1: UIButton!
    @IBOutlet weak var answerLBL: UITextView!
    @IBOutlet weak var questionLBL: UITextView!
    
    //to get the random answer to the random quetions
    @IBAction func AnswerBTN(sender: AnyObject) {
        
        answer = TreeviaArray[randomQn].valueForKey("answer") as! String
        answerLBL.text = answer
        hideSideMenuView()
    }
    
    // to get random quetions
    @IBAction func QuestionBTN(sender: AnyObject) {
        
        randomQnGenerator()
        answerLBL.text = ""
        hideSideMenuView()
    }
    
    //Used to generate random numbers
    func randomQnGenerator()
    {
        randomQn = Int(arc4random_uniform(UInt32(TreeviaArray.count)))
        question = TreeviaArray[randomQn].valueForKey("question")as! String;()
        questionLBL.text = question
        questionLBL.font = UIFont.boldSystemFontOfSize(13.0)
    }
    
    //get the data form json and sotred it into TreeviaArray
    func dataOfJson(url: String) {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        TreeviaArray = try!(NSJSONSerialization.JSONObjectWithData(data!, options:[]))as! NSArray
    }
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        
        //Used to find out whether the device has intenet connection or not
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
                self.answerLBL1.enabled = false
                self.questionLBL1.enabled = false
            })
            
            
        case .Online(.WWAN):
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treevia.php")
            randomQnGenerator()
        case .Online(.WiFi):
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
    
}
