//
//  Sting+Extension.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/6/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isStringLink() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && self.count > 0) else { return false }
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) > 0 {
            return true
        }
        return false
    }
}
