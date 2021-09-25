//
//  ThemeSettingsViewController.swift
//  Weather
//
//  Created by Alexander Rubtsov on 24.09.2021.
//

import UIKit

class ColorThemeSettingsViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = ColorThemeSettingsView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
        mainView.viewControllerOwner = self
        mainView.colorThemes = ColorThemeManager.getColorThemes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Color theme"
    }
}
