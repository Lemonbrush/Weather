//
//  AddCityViewController.swift
//  Weather
//
//  Created by Александр on 15.04.2021.
//

import UIKit
import MapKit

protocol AddCityDelegate {
    func didAddNewCity()
    func didFailAddingNewCityWithError(error: Error?)
}

class AddCityViewController: UIViewController {

    @IBOutlet weak var searchCellBackground: UIView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var welcomeImage: UIImageView!
    
    var delegate: AddCityDelegate!
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        //Setting up search cell appearance
        searchCellBackground.layer.cornerRadius = 10
        searchCellBackground.layer.cornerCurve = CALayerCornerCurve.continuous
        
        //Connect Search textField to the textFieldDidChange method
        searchBar.addTarget(self, action: #selector(AddCityViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        //change searchCompleter depends on searchBar's text
        guard let query = textField.text else {return}
        
        searchCompleter.queryFragment = query
        searchCompleter.resultTypes = .address
    }
    
    // MARK: - Helper functions
    
    //Country id to country emoji flag converter
    func countryFlag(byCode code: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in code.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return String(s)
    }

}

// MARK: - Search completer

extension AddCityViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //get result, transform it to our needs and fill our dataSource
        self.searchResults = completer.results
        self.searchResults = completer.results.filter { result in
            
            //Getting rid of any results that contain digits
            if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return false }
            if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil { return false }
            
            return true
        }
        
        DispatchQueue.main.async {
            self.searchResultsTable.reloadData()
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //handle the error
        print(error.localizedDescription)
    }
}

// MARK: - TableView methods

extension AddCityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Hide welcome image if there is something to show
        welcomeImage.isHidden = searchResults.count != 0 ? true : false
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let result = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = result.title + " " + result.subtitle
        
        let search = MKLocalSearch(request: searchRequest)

        search.start { response, error in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                
                self.dismiss(animated: true) {
                    self.delegate.didFailAddingNewCityWithError(error: error)
                }
                
                return
            }
            
            let item = response.mapItems.first!
            let itemCoordinate = item.placemark.coordinate
            
            //Save chosen city
            CityDataFileManager.addNewCity(item.name ?? "---", lat: itemCoordinate.latitude, long: itemCoordinate.longitude)
            
            self.dismiss(animated: true) {
                self.delegate?.didAddNewCity()
            }
        }
        
    }
}