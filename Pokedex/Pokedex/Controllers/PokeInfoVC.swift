//
//  PokemonInformation.swift
//  Pokedex
//
//  Created by Harrison Resnick on 2/27/21.
//

import Foundation
import UIKit

class PokeInfoVC: UIViewController {
    var pokemon: Pokemon?
    var info: [String: Any]!
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 28, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        do {
            info = try pokemon?.allProperties()
            for (property, value) in info {
                if value is [PokeType] {
                    let newVal = value as! [PokeType]
                    infoLabel.text! += "\(property.capitalized): "
                    for i in 0..<newVal.count {
                        infoLabel.text! += "\(newVal[i].rawValue)"
                        if i == newVal.count - 1 {
                            infoLabel.text! += "\n"
                        } else {
                            infoLabel.text! += ", "
                        }
                    }
                } else {
                    infoLabel.text! += "\(property.capitalized): \(value)\n"
                }
            }
        } catch {
            print("no bueno")
        }
        
        if let url: URL = URL(string: pokemon!.imageUrlLarge) {
            if let image = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: image)
            }
        }
    
        nameLabel.text = pokemon?.name
        view.addSubview(imageView)
        view.addSubview(infoLabel)
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: nameLabel.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 125),
            imageView.heightAnchor.constraint(equalToConstant: 125)
            
        ])
        
        
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor, constant: 150),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            
        ])
    }
}

/**
 Source: https://stackoverflow.com/questions/27292255/how-to-loop-over-struct-properties-in-swift
 Added !property.contains("image"), property != "name" and test for special keyword
 */

protocol Loopable {
    func allProperties() throws -> [String: Any]
}

extension Loopable {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        for (property, value) in mirror.children {
            guard let property = property, !property.contains("image"), property != "name" else {
                continue
            }
            if let range = property.range(of: "special") {
                let property = "Special " + property[range.upperBound...]
                result[property] = value
            } else {
                result[property] = value
            }
        }

        return result
    }
}
