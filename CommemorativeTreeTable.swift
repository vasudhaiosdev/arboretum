//
//  CommemorativeTreeTable.swift
//  IOS
//
//  Created by admin on 6/27/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class CommemorativeTreeTable: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, ENSideMenuDelegate, UITextFieldDelegate {
    var NoInternet:String=""
    var dimView:UIView!
    @IBOutlet weak var menu: UIBarButtonItem!
    var CommemorativeTreeArray: NSArray!
    var filtered:[String] = []
     var searchActive : Bool = false
    @IBOutlet weak var CommemorativeTable: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var treename:[String]=[]
    var sufix:[NSString]=["Mrs.","Mr.","Miss"]
    var sufixtwo:[NSString]=["Mr. and Mrs.","Mr.& Mrs."]
    var index:Int=0
    var companeyname:NSString=""
    var cfname:NSString=""
    var clname:NSString=""
    var comlname:NSString=""
    var comfname:NSString=""
    var type:NSString=""
        func dataOfJson(url: String)
        {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        //var dataError: NSError?
        CommemorativeTreeArray = try!(NSJSONSerialization.JSONObjectWithData(data!, options:[])) as! NSArray
            for i in CommemorativeTreeArray
            {
               companeyname=i.valueForKey("company") as! String
                cfname=i.valueForKey("cfname") as! String
                clname=i.valueForKey("clname") as! String
                type=i.valueForKey("type") as! NSString
                comfname=cfname
                comlname=clname
                if(companeyname.length > 0)
                {
                    comfname=companeyname
                    comlname=""
                }
                else  if(cfname.containsString(sufixtwo[0] as String)||cfname.containsString(sufixtwo[1] as String)){
                    for(i, value) in sufixtwo.enumerate()
                    {if(cfname.containsString(value as String)){
                        index=i
                        comfname=cfname.substringFromIndex(sufixtwo[index].length)
                        }}}
                else if(cfname.containsString(sufix[0] as String)||cfname.containsString(sufix[1] as String)||cfname.containsString(sufix[2] as String))
                {
                    for(i, value) in sufix.enumerate()
                    {if(cfname.containsString(value as String)){
                        index=i
                        comfname=cfname.substringFromIndex(sufix[index].length)}}}
                    
                else  if(clname.containsString(sufixtwo[0] as String)||clname.containsString(sufixtwo[1] as String))
                {
                    for(i, value) in sufixtwo.enumerate(){
                        if(clname.containsString(value as String)){
                            index=i
                            comlname=clname.substringFromIndex(sufixtwo[index].length)
                        }}}
                else  if(clname.containsString(sufix[0] as String)||clname.containsString(sufix[1] as String)||clname.containsString(sufix[2] as String))
                {
                    for(i, value) in sufix.enumerate(){
                        if(clname.containsString(value as String)){
                            index=i
                            comlname=clname.substringFromIndex(sufix[index].length)}}}
                else{
                    }
                treename.append(type.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String + " " + comfname.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String + " " + (comlname.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String) as String)}}
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = treename.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.CommemorativeTable.reloadData()
    }
    
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        
        
        if(searchActive)
        {
            cell.textLabel?.text=filtered[indexPath.row]
        }
            
        else
            
        {
            cell.textLabel?.text=treename[indexPath.row]
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(13.0)
        return cell
        
      }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(searchActive)
        {
            return filtered.count
        }
        else if (NoInternet=="NONET")
        {
            return 0
        }
        else
        {
        return CommemorativeTreeArray.count
        }
    }
    
  
    
    override func viewDidLoad()
    {
        CommemorativeTable.delegate = self
        CommemorativeTable.dataSource = self
        search.delegate = self
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        
      
        super.viewDidLoad()
        hideSideMenuView()
//        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textFieldShouldReturn")
//        view.addGestureRecognizer(tap)

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
       // dimDisplay()
        //print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
      //  brightDisplay()
       // print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
      //  print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.resignFirstResponder()
        hideSideMenuView()
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
            NoInternet="NONET"
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
              dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/commemorativetable.php")
        case .Online(.WiFi):
            print("Connected via WiFi2")
              dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/commemorativetable.php")
            
        }
        


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
        if(segue.identifier == "commMapView"){
        let item = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
        let vc = segue.destinationViewController as! CommemorativeMapViewController
        let row = self.CommemorativeTable.indexPathForSelectedRow?.row
         vc.lattitude = CommemorativeTreeArray[row!].valueForKey("latitude") as! NSString
         vc.longitude = CommemorativeTreeArray[row!].valueForKey("longitude") as! NSString
            
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
