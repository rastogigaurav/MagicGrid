//
//  GalleryRepository.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/4/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

protocol GalleryRepositoryProtocol {
    func fetchAllImages(completionHandler:@escaping (_ images:[GalleryImage]?)->())->Void
}

class GalleryRepository: NSObject,GalleryRepositoryProtocol {
    func fetchAllImages(completionHandler: @escaping ([GalleryImage]?) -> ()) {
        if let path = Bundle.main.path(forResource: "InitialGalleryResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do{
                    let decoder = JSONDecoder()
                    let images = try decoder.decode([GalleryImage].self, from: data)
                    print(images)
                    completionHandler(images)
                }catch let error{
                    print(error.localizedDescription)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}
