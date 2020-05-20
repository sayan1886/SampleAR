//
//  AFWrapper.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

import Foundation
import Alamofire

class AFWrapper: NSObject {
    
//    var documentsURL = URL(string: "")
    
    class func requestGETURL(_ strURL: String, success:@escaping ([String : Any]) -> Void, failure:@escaping (Error) -> Void) {
        AF.request(strURL).responseJSON { (responseObject) -> Void in
//            print(responseObject)
            switch responseObject.result {
                case .success(let value):
                    success(value as! [String : Any])
                    break
                case .failure(let error):
                    failure(error)
                    break
            }
        }
    }
    
    class func downloadURL(_ strURL: String, fileName: String, success:@escaping (Any, String) -> Void, failure:@escaping (Error) -> Void) {
        
        let destination : DownloadRequest.Destination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent(fileName)
//            print(documentsURL)
            return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let progressQueue = DispatchQueue(label: "com.samplear.progressQueue", qos: .utility)

        AF.download(strURL, to: destination)
            .downloadProgress(queue: progressQueue) { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseData { (responseObject) -> Void in
                print(responseObject)
                switch responseObject.result {
                    case .success(let value):
                        success(value, responseObject.fileURL?.path ?? "")
                        break
                    case .failure(let error):
                        failure(error)
                        break
                }
            }
    }
}
