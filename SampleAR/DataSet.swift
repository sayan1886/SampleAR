//
//  DataSet.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

import Foundation

class ARModel : Decodable {
    enum CodingKeys: String, CodingKey {
        case NumberOfRecordsFound
        case DataSets
        
        case DataSetId
        case DataSetName
        case CurrentVersion
        case ExpiryDate
        case FileName
        case FileSize
        case LinkToZip
        case Versions
        
        case UploadedOn
        case Version
    }
    
    public required init(from decoder: Decoder) throws {
        
    }
    
    init() {
        
    }
}

class DataSets : ARModel {
    var numberOfRecordsFound    = 0
    var dataSets                = [DataSet]()
    
    public required init(from decoder: Decoder) throws {
        try super .init(from: decoder)
        let container               = try decoder.container(keyedBy: CodingKeys.self)
        self.numberOfRecordsFound   = try container.decode(Int.self, forKey: .NumberOfRecordsFound)
        self.dataSets               = try container.decode([DataSet].self, forKey: .DataSets)
    }
    
    init(numberOfRecordsFound : Int, dataSets : [DataSet]) {
        self.numberOfRecordsFound   = numberOfRecordsFound
        self.dataSets               = dataSets
        super.init()
    }
}

class DataSet : ARModel {
    var dataSetId       = 0
    var dataSetName     = ""
    var currentVersion  = 0
    var expiryDate      = ""
    var fileName        = ""
    var fileSize        = 0
    var linkToZip       = ""
    var versions        = [Version]()
    
    public required init(from decoder: Decoder) throws {
        try super .init(from: decoder)
        let container       = try decoder.container(keyedBy: CodingKeys.self)
        self.dataSetId      = try container.decode(Int.self, forKey: .DataSetId)
        self.dataSetName    = try container.decode(String.self, forKey: .DataSetName)
        self.currentVersion = try container.decode(Int.self, forKey: .CurrentVersion)
        self.expiryDate     = try container.decode(String.self, forKey: .ExpiryDate)
        self.fileName       = try container.decode(String.self, forKey: .FileName)
        self.fileSize       = try container.decode(Int.self, forKey: .FileSize)
        self.linkToZip      = try container.decode(String.self, forKey: .LinkToZip)
        self.versions       = try container.decode([Version].self, forKey: .Versions)
    }
    
    init(dataSetId: Int, expiryDate: String, dataSetName: String,  currentVersion: Int, fileName: String, fileSize: Int, linkToZip: String, versions: [Version]) {
        self.dataSetId      = dataSetId
        self.dataSetName    = dataSetName
        self.currentVersion = currentVersion
        self.expiryDate     = expiryDate
        self.fileName       = fileName
        self.fileSize       = fileSize
        self.linkToZip      = linkToZip
        self.versions       = versions
        super.init()
    }
}

class Version : ARModel {
    var fileName    = ""
    var fileSize    = 0
    var linkToZip   = ""
    var uploadedOn  = ""
    var version     =  0

    public required init(from decoder: Decoder) throws {
        try super .init(from: decoder)
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        self.fileName   = try container.decode(String.self, forKey: .FileName)
        self.fileSize   = try container.decode(Int.self, forKey: .FileSize)
        self.linkToZip  = try container.decode(String.self, forKey: .LinkToZip)
        self.uploadedOn = try container.decode(String.self, forKey: .UploadedOn)
        self.version    = try container.decode(Int.self, forKey: .Version)
    }
    
    init(fileName: String, fileSize: Int, linkToZip: String, uploadedOn: String, version: Int) {
        self.fileName   = fileName
        self.fileSize   = fileSize
        self.linkToZip  = linkToZip
        self.uploadedOn = uploadedOn
        self.version    = version
        super.init()
    }
}
