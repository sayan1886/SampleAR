//
//  ViewController.swift
//  SampleAR
//
//  Created by Sayan Chatterjee on 20/05/20.
//  Copyright © 2020 Sayan Chatterjee. All rights reserved.
//

import UIKit
import JHSpinner


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var datasets: DataSets
    var spinner: JHSpinnerView
    var reuseIdentifier = "datasetCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        let ds = [DataSet]()
        self.datasets = DataSets(numberOfRecordsFound: 0, dataSets: ds);
        
        self.spinner = JHSpinnerView(frame:UIScreen.main.bounds);
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "All Datasets"
        
        //Add Spinner
        self.spinner = JHSpinnerView.showOnView(self.view, spinnerColor:UIColor.blue, overlay:.custom(CGSize(width: 300, height: 200), 20), overlayColor:UIColor.black.withAlphaComponent(0.6), fullCycleTime:4.0, text:"Loading")
        view.addSubview(spinner)
        
        let params = [String : String] ()
        self.getDataSets(url: SampleAR.URL(baseURL: SampleAR.BASE_URL, path: SampleAR.ALL_DATA_SET_PATH, params: [:]), parameters: params)
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.destination is DetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                
                let vc      = segue.destination as? DetailsViewController
                let ds      = self.datasets.dataSets[indexPath.row]
                let dsId    = String(ds.dataSetId)
                let dsName  = ds.dataSetName
                    
                vc?.dataSetId   = dsId
                vc?.dataSetName = dsName
            }
        }
    }
    
    //MARK: - Table View data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasets.numberOfRecordsFound
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        // Configure the cell’s contents.
        let ds = self.datasets.dataSets[indexPath.row]
        let dsName = "Datset: " + ds.dataSetName
        let dsVersion = "Ver " + String(ds.currentVersion)
        cell.textLabel?.text = dsName
        cell.detailTextLabel?.text = dsVersion

        return cell
    }
    
    //MARK: - Table View delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Configure the cell’s contents.
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: - Networking
    func getDataSets(url: String, parameters: [String: String]) {
        
        AFWrapper.requestGETURL(url, success: { (responseObject) in
//            print(responseObject)
            self.updateDataSet(response: responseObject)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: - JSON Parsing
    func updateDataSet (response : Any) {
        let jsonData = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
        let reqJSONStr = String(data: jsonData, encoding: .utf8)
        let data = reqJSONStr?.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        self.datasets = try! jsonDecoder.decode(DataSets.self, from: data!)
        self.tableView.reloadData()
        self.spinner.dismiss()
    }
}
