//
//  GalleryViewModel.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/4/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

enum GalleryCellType:Int {
    case image = 0,
    addMore
}

class GalleryViewModel: NSObject {

    var reloadGallery:(()->Void) = { }
    
    var displayGallery : DisplayGalleryProtocol
    
    var images:[GalleryImage] = []
    
    init(displayGallery:DisplayGalleryProtocol) {
        self.displayGallery = displayGallery
    }
    
    func didAppear(){
        self.displayGallery.displayAllImages {[unowned self] allImages in
            if let allImg = allImages{
                self.images = allImg
                self.reloadGallery()
            }
        }
    }
    
    func numberOfSections()->Int{
        return 1
    }
    
    func numberOfItemsInSection(section:Int)->Int{
        return (self.images.count) + 1
    }
    
    func cellType(for indexpath:IndexPath)->GalleryCellType{
        if (self.images.count > 0 && indexpath.row == self.images.count) || self.images.count == 0{
            return .addMore
        }
        
        return .image
    }
    
    func image(forCellAt indexpath:IndexPath)->GalleryImage{
        return self.images[indexpath.row]
    }
    
    func remove(imageAt indexpath:IndexPath){
        self.images.remove(at: indexpath.row)
    }
    
    func add(imageWith urlStrig:String){
        let image = GalleryImage(uuid: "588e2c7f-40de-4c4d-ac74-2884daf5ecc8", imageUrlString: urlStrig)
        self.images.append(image)
        self.reloadGallery()
    }
    
    func canMove(itemFrom indexpath:IndexPath)->Bool{
        return self.cellType(for: indexpath) == .image
    }
    
    func canDrop(itemAt indexpath:IndexPath)->Bool{
        return self.cellType(for: indexpath) == .addMore
    }
    
    func size(forCellAt indexpath:IndexPath)->CGSize{
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth - 41) / 3
        let cellPadding:CGFloat = 10.0
        
        if (self.images.count > 0 && indexpath.row == 0) {
            return CGSize(width: 2*scaleFactor + cellPadding, height: 2*scaleFactor+cellPadding)
        }
        
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
    func move(itemFrom sourceIndexpath:IndexPath,to destinationIndexpath:IndexPath){
        let temp = self.images.remove(at: sourceIndexpath.item)
        self.images.insert(temp, at: destinationIndexpath.item)
    }
}

extension GalleryViewModel{
    static func create() -> GalleryViewModel{
        let repository = GalleryRepository()
        let displayGallery = DisplayGallery(with: repository)
        return GalleryViewModel(displayGallery: displayGallery)
    }
}
