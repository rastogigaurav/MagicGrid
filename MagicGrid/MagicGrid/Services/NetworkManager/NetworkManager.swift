//
//  NetworkManager.swift
//  MagicGrid
//
//  Created by Gaurav Rastogi on 5/4/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {

    typealias apiSuccess = (_ result: NSDictionary) -> Void
    typealias apiFailure = (_ error: NSDictionary?) -> Void
    
    class func get(_ strURL: String, parameters: [String: AnyObject], success:@escaping apiSuccess, failure:@escaping apiFailure) {
        Alamofire.request(strURL, parameters: parameters).responseJSON { (responseObject) -> Void in
            print("\nmakeGetCall:\n\(responseObject)")
            
            if responseObject.result.isSuccess {
                let JSON = responseObject.result.value as? NSDictionary
                if (JSON != nil) {
                    success(JSON!)
                }
                else {
                    failure(["error":"API Format Error", "statusCode":999])
                }
            }
            
            if responseObject.result.isFailure {
                let httpError: NSError = responseObject.result.error! as NSError
                let statusCode = httpError.code
                let error:NSDictionary = ["error" : httpError,"statusCode" : statusCode]
                failure(error)
            }
        }
    }
    
    class func post(_ strURL: String, parameters: [String: AnyObject], success:@escaping apiSuccess, failure:@escaping apiFailure) {
        Alamofire.request(strURL, method: .post, parameters: parameters).responseJSON { (responseObject) -> Void in
            print("\nmakePostCall:\n\(responseObject)")
            
            if responseObject.result.isSuccess {
                let JSON = responseObject.result.value as? NSDictionary
                if (JSON != nil) {
                    success(JSON!)
                }
                else {
                    failure(["error":"API Format Error", "statusCode":999])
                }
            }
            if responseObject.result.isFailure {
                let httpError: NSError = responseObject.result.error! as NSError
                let statusCode = httpError.code
                let error:NSDictionary = ["error" : httpError,"statusCode" : statusCode]
                failure(error)
            }
        }
    }
}
