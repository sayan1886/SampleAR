//
//  SampleAR.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

import Foundation


//MARK: - API URL
let BASE_URL = "https://ar4alla9820668f.hana.ondemand.com/AR4ALL/api/datasets/"

let ALL_DATA_SET_PATH   = "get-all-data-sets"
let DATA_SET_PATH       = "get-data-set-by-id"

let DATS_SET_PATH_PARAMS    = ["datasetid"]

func URL (baseURL : String, path: String, params : [String : String]) -> String{
    let urlParams = params.compactMap({ (key, value) -> String in
        return "\(key)=\(value)"
    }).joined(separator: "&")
    
    let url = urlParams.count > 0 ? baseURL + path + "?" + urlParams : baseURL + path
    return url
}
