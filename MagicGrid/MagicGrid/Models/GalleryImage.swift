//
//  GalleryImage.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/5/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

struct GalleryImage : Codable {
    
    var uuid:String
    var imageUrlString:String
    
    private enum CodingKeys: String, CodingKey {
        case uuid
        case imageUrlString
    }
}
