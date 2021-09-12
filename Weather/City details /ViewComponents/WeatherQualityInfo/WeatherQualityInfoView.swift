//
//  WeatherQualityInfoView.swift
//  Weather
//
//  Created by Alexander Rubtsov on 11.09.2021.
//

import UIKit

class WeatherQualityInfoView: UIView {
    
    //MARK: - Private properties
    
    private var backgroundView: UIView = {
        let view = UIView()
        DesignManager.setBackgroundStandartShape(layer: view.layer)
        DesignManager.setBackgroundStandartShadow(layer: view.layer)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var uvIndexItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: "sun.max")?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = .systemGray4
        qualityItem.titleLabel.text = "UV index"
        qualityItem.subTitleLabel.text = "-"
        return qualityItem
    }()
    
    private var humidityItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: "drop")?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = .systemGray4
        qualityItem.titleLabel.text = "Humidity"
        qualityItem.subTitleLabel.text = "-"
        return qualityItem
    }()
    
    private var cloudinessItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: "cloud")?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = .systemGray4
        qualityItem.titleLabel.text = "Cloudiness"
        qualityItem.subTitleLabel.text = "-"
        return qualityItem
    }()
    
    private var windItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: "wind")?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = .systemGray4
        qualityItem.titleLabel.text = "Wind"
        qualityItem.subTitleLabel.text = "-"
        return qualityItem
    }()
    
    private var pressureItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: "arrow.down.to.line")?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = .systemGray4
        qualityItem.titleLabel.text = "Pressure"
        qualityItem.subTitleLabel.text = "-"
        return qualityItem
    }()
    
    private var visibilityItemView: WeatherQualityItemView = {
        let qualityItem = WeatherQualityItemView()
        qualityItem.imageView.image = UIImage(systemName: "eye")?.withRenderingMode(.alwaysTemplate)
        qualityItem.tintColor = .systemGray4
        qualityItem.titleLabel.text = "Visibility"
        qualityItem.subTitleLabel.text = "-"
        return qualityItem
    }()
    
    //StackViews
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 30
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let firstColumnStackView = makeStackViewItems(stackViews: [humidityItemView, cloudinessItemView])
        let secondColumnStackView = makeStackViewItems(stackViews: [uvIndexItemView, pressureItemView])
        let thirdColumnStackView = makeStackViewItems(stackViews: [windItemView, visibilityItemView])
        
        mainStackView.addArrangedSubview(firstColumnStackView)
        mainStackView.addArrangedSubview(secondColumnStackView)
        mainStackView.addArrangedSubview(thirdColumnStackView)
        
        addSubview(backgroundView)
        backgroundView.addSubview(mainStackView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    
    func setupValues(weatherData: WeatherModel) {
        humidityItemView.subTitleLabel.text = weatherData.humidityString
        windItemView.subTitleLabel.text = weatherData.windString
        cloudinessItemView.subTitleLabel.text = weatherData.cloudinessString
        pressureItemView.subTitleLabel.text = weatherData.pressureString
        visibilityItemView.subTitleLabel.text = weatherData.visibilityString
        uvIndexItemView.subTitleLabel.text = String(weatherData.uviIndex)
        
        humidityItemView.stackView.layoutIfNeeded()
    }
    
    //MARK: - Private functions
    
    private func setupConstraints() {
        //BackgroundView
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        //Main stackView
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    private func makeStackViewItemInfo(image: UIImageView, title: UILabel, subtitle: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(title)
        stackView.addArrangedSubview(subtitle)
        return stackView
    }
    
    private func makeStackViewItems(stackViews: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        for stack in stackViews {
            stackView.addArrangedSubview(stack)
        }
        return stackView
    }
}