//
//  DisplayGallery.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/4/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

protocol DisplayGalleryProtocol {
    func displayAllImages(completionHandler:@escaping (_ images:[GalleryImage]?)->())->Void
}

class DisplayGallery: NSObject,DisplayGalleryProtocol {
    
    var repository : GalleryRepositoryProtocol
    
    init(with galleryRepository:GalleryRepositoryProtocol) {
        self.repository = galleryRepository
    }
    
    func displayAllImages(completionHandler: @escaping ([GalleryImage]?) -> ()) {
        self.repository.fetchAllImages { images in
            completionHandler(images)
        }
    }
}
