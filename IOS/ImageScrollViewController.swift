//
//  ImageScrollViewController.swift
//  IOS
//
//  Created by admin on 7/14/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController {

    let appy: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var pageIndex: Int!
    var imageFile:String!
    
    
    @IBOutlet weak var imageView: UIImageView!
  
    //Used to view the images in detail view controller
    override func viewDidLoad()
    {        let image=NSData(contentsOfURL: NSURL(string:imageFile)!)
        if(image == nil){
        imageView.image = UIImage(contentsOfFile: imageFile)}
        else
        {
            imageView.image = UIImage(data: image!)}
        super.viewDidLoad()
        }
    
  }
