//
//  GalleryRepository.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/4/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

fileprivate struct Response : Codable{
    let items:[GalleryImage]?
}

protocol GalleryRepositoryProtocol {
    func fetchAllImages(completionHandler:@escaping (_ images:[GalleryImage]?)->())->Void
}

class GalleryRepository: NSObject,GalleryRepositoryProtocol {
    func fetchAllImages(completionHandler: @escaping ([GalleryImage]?) -> ()) {
        if let path = Bundle.main.path(forResource: "InitialGalleryResponse", ofType: "json") {
            NetworkManager.get(path, success: { data in
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    print(response.items as Any)
                    completionHandler(response.items)
                } catch let error {
                    print(error.localizedDescription)
                }
            }, failure: { error in
                print(error?.localizedDescription as Any)
            })
        } else {
            print("Invalid filename/path.")
        }
    }
}
