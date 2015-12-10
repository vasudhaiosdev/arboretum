//
//  deatilimageViewController.swift
//  Arboretum
//
//  Created by Naresh kumar Nagulavancha on 12/6/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit

class deatilimageViewController: UIViewController {
    var ind: String=""
    func getphoto(photo:String)
    {
        let image=NSData(contentsOfURL: NSURL(string:photo)!)
        
        imageview.image =
            UIImage(data:image!)
        
        print("sucess")
        
        
    }
    @IBOutlet var imageview: UIImageView!
    // var myimage = UIImage(named: "Cancel_Upload")
    override func viewDidLoad() {
    getphoto(ind)
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
        
}
}