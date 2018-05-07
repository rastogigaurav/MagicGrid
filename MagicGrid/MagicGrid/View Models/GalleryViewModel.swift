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
        if (self.images.count > 1 && indexpath.row == self.images.count) || self.images.count == 0{
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
    
    func canMove(cellAt indexpath:IndexPath)->Bool{
        if indexpath.row == images.count{
            return false
        }
        return true
    }
    
    func swap(cellsAt sourceIndexpath:IndexPath, destinationIndexpath:IndexPath){
        let temp = self.images[sourceIndexpath.row]
        self.images[sourceIndexpath.row] = self.images[destinationIndexpath.row]
        self.images[destinationIndexpath.row] = temp
    }
}

extension GalleryViewModel{
    static func create() -> GalleryViewModel{
        let repository = GalleryRepository()
        let displayGallery = DisplayGallery(with: repository)
        return GalleryViewModel(displayGallery: displayGallery)
    }
}
