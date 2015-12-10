//
//  adoptatreeViewController.swift
//  IOS
//
//  Created by Naresh kumar Nagulavancha on 7/8/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class adoptatreeViewController: UIViewController, ENSideMenuDelegate {
   
    var dimView:UIView!
    
//    @IBAction func back(sender: AnyObject)
//    {
//        var vc:UIViewController!
//        vc = storyboard!.instantiateViewControllerWithIdentifier("HomeViewController")
//        
//        self.navigationController?.pushViewController(vc, animated: true)
//        
//    }
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideSideMenuView()
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        //dimDisplay()
       // print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        //brightDisplay()
        //print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        //print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    func dimDisplay(){
        
        self.dimView = UIView(frame: self.view.frame)
        self.dimView.backgroundColor = UIColor.blackColor()
        self.dimView.alpha = 0
        view.addSubview(self.dimView)
        view.bringSubviewToFront(self.dimView)
        UIView.animateWithDuration(0.3, animations: {self.dimView.alpha = 0.3})
        
    }
    
    func brightDisplay(){
        UIView.animateWithDuration(0.3, animations: {self.dimView.alpha = 0})
        self.dimView.removeFromSuperview()
        self.dimView = nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Donors"){
        
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
}
        if(segue.identifier == "commoTree"){
            
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
        }
        if(segue.identifier == "supportArboretum"){
            
            let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = item
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
