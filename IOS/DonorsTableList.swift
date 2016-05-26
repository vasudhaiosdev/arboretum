//
//  DonorsTableList.swift
//  IOS
//
//  Created by admin on 6/27/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit


class DonorsTableList: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, ENSideMenuDelegate
{
    var NoInternet:String = ""
    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var search: UISearchBar!
    var DonorsArray: NSArray!
    var filtered:[String] = []
    var searchActive : Bool = false
    @IBOutlet weak var DonorsTable: UITableView!
    var donarnames:[String]=[]
    var companeyname:NSString=""
    var dfname:NSString=""
    var dlname:NSString=""
    var donarlname:NSString=""
    var donarfname:NSString=""
    var sufix:[NSString]=["Mrs.","Mr.","Ms."]
    var sufixtwo:[NSString]=["Mr. and Mrs.","Mr.& Mrs."]
    var index:Int=0
  
    //Used to fetch the data from json array and stored it in the donorsarray
    func dataOfJson(url: String)
    {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
       // var dataError: NSError?
        DonorsArray = try!( NSJSONSerialization.JSONObjectWithData(data!, options:[])) as! NSArray
        for i in DonorsArray
        {   companeyname=i.valueForKey("companyname") as! String
            dfname=i.valueForKey("dfname") as! String
            dlname=i.valueForKey("dlname") as! String
            donarfname=dfname
            donarlname=dlname
            if(companeyname.length > 0)
            {
                donarfname=companeyname
                donarlname=""
            }
            else  if(dfname.containsString(sufixtwo[0] as String)||dfname.containsString(sufixtwo[1] as String)){
                for(i, value) in sufixtwo.enumerate()
                {if(dfname.containsString(value as String)){
                    index=i
                    donarfname=dfname.substringFromIndex(sufixtwo[index].length)
                    }}}
            else if(dfname.containsString(sufix[0] as String)||dfname.containsString(sufix[1] as String)||dfname.containsString(sufix[2] as String))
            {
                for(i, value) in sufix.enumerate()
                {if(dfname.containsString(value as String)){
                    index=i
                    donarfname=dfname.substringFromIndex(sufix[index].length)            }
                }
            }
                
            else  if(dlname.containsString(sufixtwo[0] as String)||dlname.containsString(sufixtwo[1] as String))
            {
                for(i, value) in sufixtwo.enumerate(){
                    if(dlname.containsString(value as String)){
                        index=i
                        donarlname=dlname.substringFromIndex(sufixtwo[index].length)
                    }}}
            else  if(dlname.containsString(sufix[0] as String)||dlname.containsString(sufix[1] as String)||dlname.containsString(sufix[2] as String))
            {
                for(i, value) in sufix.enumerate(){
                    if(dlname.containsString(value as String)){
                        index=i
                        donarlname=dlname.substringFromIndex(sufix[index].length)
                    }}}
            else{
                
            }
            
            donarnames.append(donarfname.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String + " " + (donarlname.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) as String) as String)
            
            
        }
    }
    
    //Used to search the data in donarnames as alphabetical order
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
        
        filtered = donarnames.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.DonorsTable.reloadData()
    }
    
    //Dispaly the  donarnames array in table format
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        if(searchActive)
        {
            cell.textLabel?.text=filtered[indexPath.row]
        }
        else
        {
            cell.textLabel?.text=donarnames[indexPath.row]
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
       else if NoInternet=="NONET"
        {
            return 0
        }
        
        else
        {
            return DonorsArray.count
        }
    }
    

    
    override func viewWillAppear(animated: Bool) {
        hideSideMenuView()
         self.navigationItem.backBarButtonItem?.title = "Back"
  
        

        
    }
    override func viewDidLoad()
    {
         self.navigationItem.backBarButtonItem?.title = "Back"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
       
        //Used to find out if the device is connect to in the internt or not
        func networkStatusChanged(notification: NSNotification) {
            _ = notification.userInfo
            
        }
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            NoInternet = "NONET"
            //print("Not connected")
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
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treedonortable.php")
        case .Online(.WiFi):
            dataOfJson("http://csgrad10.nwmissouri.edu/arboretum/treedonortable.php")
            
        }
        
        search.delegate=self
        DonorsTable.delegate=self
        DonorsTable.dataSource=self
        super.viewDidLoad()
        hideSideMenuView()
    }
    
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideSideMenuView()
    }
    
    
}
