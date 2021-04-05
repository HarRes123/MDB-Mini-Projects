//
//  WeatherCollectionViewCell.swift
//  WeatherDB
//
//  Created by Harrison Resnick on 4/4/21.
//

import Foundation
import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = String(describing: WeatherCollectionViewCell.self)
    
    var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            
            let completion: (UIImage) -> Void = { image in
                DispatchQueue.main.sync {
                    self.weatherIcon.image = image
                }
            }
            
            DispatchQueue.main.async {
                self.cityLabel.text = "\(weather.name)"
                self.weatherLabel.text = weather.condition[0].description.capitalized
                self.currentLabel.text = "Current: \(weather.main.temperature) °F"
                self.maxLabel.text = "High: \(weather.main.maxTemperature) °F"
                self.minLabel.text = "Low: \(weather.main.minTemperature) °F"
                self.feelLabel.text = "Feels Like: \(weather.main.heatIndex) °F"
                self.pressureLabel.text = "Pressure: \(weather.main.pressure) hPa"
                self.humidityLabel.text = "Humidity: \(weather.main.humidity)%"
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let icon = "https://openweathermap.org/img/wn/" + weather.condition[0].icon + "@4x.png"
                if let url: URL = URL(string: icon) {
                    if let image = try? Data(contentsOf: url) {
                        completion(UIImage(data: image)!)
                    }
                }
            }
        }
    }
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feelLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pressureLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let deleteButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        btn.backgroundColor = .systemRed
        btn.setTitle("Delete", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.layer.cornerRadius = 15
        btn.layer.borderWidth = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        changeBoarder()
    }
    
    private func changeBoarder() {
        if self.traitCollection.userInterfaceStyle == .light {
            contentView.layer.borderColor = UIColor.black.cgColor
            deleteButton.layer.borderColor = UIColor.black.cgColor
        } else {
            contentView.layer.borderColor = UIColor.lightGray.cgColor
            deleteButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cityLabel)
        contentView.addSubview(weatherLabel)
        contentView.addSubview(currentLabel)
        contentView.addSubview(maxLabel)
        contentView.addSubview(minLabel)
        contentView.addSubview(feelLabel)
        contentView.addSubview(pressureLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(deleteButton)
                
        contentView.backgroundColor = .secondarySystemFill
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        
        changeBoarder()
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cityLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
           
            weatherIcon.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 150),
            weatherIcon.widthAnchor.constraint(equalToConstant: 150),
           
            weatherLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            weatherLabel.topAnchor.constraint(equalTo: cityLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),

            currentLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            currentLabel.topAnchor.constraint(equalTo: weatherLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
           
            maxLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            maxLabel.topAnchor.constraint(equalTo: currentLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
           
            minLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            minLabel.topAnchor.constraint(equalTo: maxLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
           
            feelLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            feelLabel.topAnchor.constraint(equalTo: minLabel.bottomAnchor, constant: 10),
           
            pressureLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            pressureLabel.topAnchor.constraint(equalTo: feelLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
           
            humidityLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            humidityLabel.topAnchor.constraint(equalTo: pressureLabel.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            deleteButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            deleteButton.topAnchor.constraint(equalTo: pressureLabel.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            deleteButton.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
