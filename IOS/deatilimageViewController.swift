//
//  deatilimageViewController.swift
//  Arboretum
//
//  Created by Vasudha Jags on 12/6/15.
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
     }
  
    @IBOutlet var imageview: UIImageView!
    override func viewDidLoad() {
    getphoto(ind)
 }
}