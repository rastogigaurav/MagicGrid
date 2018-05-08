//
//  NetworkManager.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/4/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    typealias apiSuccess = (_ data: Data) -> Void
    typealias apiFailure = (_ error: Error?) -> Void
    
    class func get(_ strURL: String, success:@escaping apiSuccess, failure:@escaping apiFailure) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: strURL), options: .alwaysMapped)
                success(data)
        } catch let error {
            failure(error)
        }
    }
}
