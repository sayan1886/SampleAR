//
//  DetailsViewController.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

import UIKit
import Zip
import JHSpinner


class DetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var dataSetId: String = ""
    var dataSetName: String = ""
    var reuseIdentifier = "imageCell"
    var imageArray = Array<Any>()
    var dataset: DataSet
    var spinner: JHSpinnerView
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
    private let itemsPerRow: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        
        self.dataset = DataSet(dataSetId: 0, expiryDate: "", dataSetName: "", currentVersion: 0, fileName: "", fileSize: 0, linkToZip: "", versions: [])
        self.spinner = JHSpinnerView(frame:UIScreen.main.bounds);
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Dataset"
        
        //Add Spinner
//        self.spinner = JHSpinnerView.showOnView(self.view, spinnerColor:UIColor.blue, overlay:.custom(CGSize(width: 300, height: 200), 20), overlayColor:UIColor.black.withAlphaComponent(0.6), fullCycleTime:4.0, text:"Loading")
//        view.addSubview(spinner)
        
        self.spinner = JHSpinnerView.showDeterminiteSpinnerOnView(self.view)
        spinner.progress = 0.0
        view.addSubview(self.spinner)
        
        var params = [String : String] ()
        for param in SampleAR.DATS_SET_PATH_PARAMS {
            params[param] = self.dataSetId
        }
        self.getDataSet(url: SampleAR.URL(baseURL: SampleAR.BASE_URL, path: SampleAR.DATA_SET_PATH, params: params), parameters: params)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = dataSetName + " Images"
    }
    
    //MARK: - Collection View data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ARImageViewCell
        let image = photo(for: indexPath)
        cell.backgroundColor = .white
        cell.imageView.image = image
        
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        cell.contentView.layer.masksToBounds = true;

        
        return cell
    }
    
    //MARK: - Networking
    func getDataSet(url: String, parameters: [String: String]) {
        
        AFWrapper.requestGETURL(url, success: { (responseObject) in
//            print(responseObject)
            self.updateDataSet(response: responseObject)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getZip (url: String, fileName: String) {
        AFWrapper.downloadURL(url, fileName: fileName,
                success: { (fileData, filePath) in
//                    print(filePath)
                    self.unzipFile(unzipPath: filePath)
                    
        }, failure: { (error) in
            print(error.localizedDescription)
        }, update: { (progress) in
            let floatValue = NSNumber.init(value: (progress as AnyObject).fractionCompleted).floatValue
            print (floatValue)
            self.spinner.progress = CGFloat(floatValue)
        })
    }
    
    //MARK: - JSON Parsing
    func updateDataSet (response : Any) {
        let jsonData = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        let data = reqJSONStr?.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        self.dataset = try! jsonDecoder.decode(DataSet.self, from: data!)
        self.getZip(url: self.dataset.linkToZip, fileName: self.dataset.fileName)
    }
    
    //MARK: - Unzip and Load
    func unzipFile(unzipPath: String)  {
        do {
            let filePath = NSURL.fileURL(withPath: unzipPath)
            let unzipDirectory = try Zip.quickUnzipFile(filePath) // Unzip
            self.imageArray = contentsOfDirectory(at: unzipDirectory, recursive: true)
                                            .filter{    $0.pathExtension == "png"   ||
                                                        $0.pathExtension == "PNG"   ||
                                                        $0.pathExtension == "jpg"   ||
                                                        $0.pathExtension == "JPG"   ||
                                                        $0.pathExtension == "jpeg"  ||
                                                        $0.pathExtension == "JEPG" }
//            print(self.imageArray)
        }
        catch {
          print("Something went wrong")
        }
        self.spinner.dismiss()
        self.collectionView.reloadData()
        self.button.isEnabled = true
    }
    
    func contentsOfDirectory(at: URL, recursive: Bool ) -> [URL] {
        var directoryContents = Array<URL>()
        do {
            let fileManager = FileManager.default
            if recursive {
//                let path = at.absoluteString
                fileManager.enumerator(at: at, includingPropertiesForKeys: nil)?.forEach({ (e) in
                    guard let url = e as? URL else { return }
//                    let relativeURL = URL(fileURLWithPath: s, relativeTo: at)
//                    let url = relativeURL.absoluteURL
                    if !url.isDirectory {
                        directoryContents.append(url)
                    }
                })
            }
            else{
                directoryContents = try fileManager.contentsOfDirectory(at: at, includingPropertiesForKeys: nil)
            }
        }
        catch {
          print("Something went wrong")
        }
        return directoryContents
    }
    
    func photo(for indexPath: IndexPath) -> UIImage {
        let filePath = self.imageArray[indexPath.row] as! URL
        var image: UIImage? = nil
        do {
            let imageData = try Data(contentsOf: filePath)
            image = UIImage(data: imageData)!
        } catch {
            print("Error loading image : \(error)")
        }
        return image!
    }
}


extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Collection View Flow Layout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

      let paddingSpace = sectionInsets.left * ( itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.top
    }

}

//MARK: - Image Cell
class ARImageViewCell: UICollectionViewCell {
     @IBOutlet weak var imageView: UIImageView!
    
    
}

extension URL {
    var isDirectory: Bool {
        let values = try? resourceValues(forKeys: [.isDirectoryKey])
        return values?.isDirectory ?? false
    }
}
