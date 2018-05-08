//
//  ImageCell.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/6/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    
    var delete:((_ sender:UIButton)->Void) = {_ in }
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(cellFor image:GalleryImage){
        self.imageView.sd_setImage(with: URL(string: image.imageUrlString), placeholderImage: UIImage(named: "appLogo"))
    }
    
    @IBAction func didTapDelete(_ sender: UIButton) {
        self.delete(sender)
    }    
}
