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
    
    //MARK: - Public properties
    
    var delegate: AddCityDelegate?
    
    private let addCityView = AddCityView()
    
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = addCityView
        addCityView.viewControllerOwner = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Functions
    
    func didChoseCity(_ name: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        CityDataFileManager.addNewCity(name, lat: lat, long: long)
        
        dismiss(animated: true) {
            self.delegate?.didAddNewCity()
        }
    }
    
    func didFinishedWithError(error: Error?) {
        delegate?.didFailAddingNewCityWithError(error: error)
    }
}