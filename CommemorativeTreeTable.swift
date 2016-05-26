//
//  CommemorativeTreeTable.swift
//  IOS
//
//  Created by Vasudha Jags on 6/27/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class CommemorativeTreeTable: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, ENSideMenuDelegate, UITextFieldDelegate {
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var CommemorativeTable: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    var NoInternet:String=""
    var dimView:UIView!
    var CommemorativeTreeArray: NSArray!
    var filtered:[String] = []
    var searchActive : Bool = false
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
    
    //Function that is used to add josn data to an array named CommemorativeTreeArray and after add some contraints to cfname and clname to remove MS and MR from there names and added both of them to a single string
        func dataOfJson(url: String)
        {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
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

    //Used to search the data in alphabetical order
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
    
    
   //Display the commemorative tree(tree name) list in table form
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
        
                //Used to find if the net is connected to the device or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            NoInternet="NONET"
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
              dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/commemorativetable.php")
        case .Online(.WiFi):
              dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/commemorativetable.php")
            
        }
    }
    
//By cliking on the cell it navigate to the tree physical location throught the map
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
}
