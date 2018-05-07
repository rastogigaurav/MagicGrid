//
//  AddMoreCell.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/6/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

class AddMoreCell: UICollectionViewCell {
    
    var addMore:(()->Void) = { }
    
    @IBAction func didTapAddMore(_ sender: UIButton) {
        self.addMore()
    }
}
