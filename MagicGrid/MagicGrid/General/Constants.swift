//
//  Constants.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/5/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionViewCell: ReusableView {
}

let endPoint = "http://localhost/InitialGalleryResponse.json"
