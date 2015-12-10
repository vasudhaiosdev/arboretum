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
    
    override func viewDidLoad()
    {
        
        
        let image=NSData(contentsOfURL: NSURL(string:imageFile)!)
        if(image == nil){
        imageView.image = UIImage(contentsOfFile: imageFile)}
        else{
        
            imageView.image = UIImage(data: image!)}
        
    
        
      
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
