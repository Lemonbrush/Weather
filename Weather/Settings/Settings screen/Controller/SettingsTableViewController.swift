//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Александр on 20.06.2021.
//

import UIKit

struct SettingsSection {
    var title: String?
    var cells: [UITableViewCell]
}

class SettingsViewController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var unitsSettingsCell = UnitsSettingsCell(colorThemeComponent: colorThemeComponent)
    private lazy var colorThemeSettingsCell = ColorThemeSettingsCell(colorThemeComponent: colorThemeComponent)
    
    private lazy var mainView = SettingsView(colorTheme: colorThemeComponent)

    // MARK: - Public properties

    var mainMenuDelegate: MainMenuDelegate?
    var colorThemeComponent: ColorThemeProtocol

    // MARK: - Lifecycle
    
    init(colorThemeComponent: ColorThemeProtocol) {
        self.colorThemeComponent = colorThemeComponent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.viewControllerOwner = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorThemeComponent.colorTheme.settingsScreen.labelsColor]
        navigationItem.title = "Settings"
        
        unitsSettingsCell.delegate = self
        colorThemeSettingsCell.delegate = self
        
        let appSettingsSection = SettingsSection(title: "APP",
                                                 cells: [unitsSettingsCell,
                                                         colorThemeSettingsCell])
        
        mainView.settingsSections?.append(appSettingsSection)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorThemeSettingsCell.refresh()
    }
}

extension SettingsViewController: UnitSwitchCellDelegate {
    func unitSwitchToggled(_ value: Int) {
        switch value {
        case 0:
            UserDefaultsManager.setUnitData(with: K.UserDefaults.metric)
        case 1:
            UserDefaultsManager.setUnitData(with: K.UserDefaults.imperial)
        default:
            break
        }
        
        mainMenuDelegate?.fetchWeatherData()
    }
}

extension SettingsViewController: ColorThemeSettingsCellDelegste {
    func presentColorThemes() {
        let colorThemeSettingsViewController = ColorThemeSettingsViewController(colorThemeComponent: colorThemeComponent)
        colorThemeSettingsViewController.mainMenuDelegate = mainMenuDelegate
        colorThemeSettingsViewController.colorThemeComponent = colorThemeComponent
        
        navigationController?.pushViewController(colorThemeSettingsViewController,
                                                 animated: true)
    }
}
