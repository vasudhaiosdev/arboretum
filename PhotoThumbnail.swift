//
//  PhotoThumbnail.swift
//  Arboretum
//
//  Created by Naresh kumar Nagulavancha on 12/6/15.
//  Copyright © 2015 Student. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    
    @IBOutlet var imgView : UIImageView!
    
    
    func setThumbnailImage(thumbnailImage: UIImage){
        self.imgView.image = thumbnailImage
    }
    
}
