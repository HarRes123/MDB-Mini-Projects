//
//  FiltersVC.swift
//  Pokedex
//
//  Created by Harrison Resnick on 2/28/21.
//

import Foundation
import UIKit

protocol SelectedTypesProtocol {
    func sendSelectedTypes(data: [String])
}

class FiltersVC: UIViewController {
    let stackView = UIStackView()
    var selectedTypes: [String] = []
    var delegate: SelectedTypesProtocol? = nil
    let dismissButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.backgroundColor = .cyan

        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        for attribute in PokeType.allCases {
            let button = UIButton()
            button.setTitleColor(.gray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.setTitle(attribute.rawValue, for: .normal)
            if selectedTypes.contains(attribute.rawValue) {
                button.isSelected = true
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        dismissButton.addTarget(self, action: #selector(didDismiss(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedTypes.append(sender.titleLabel!.text!)
        } else {
            if selectedTypes.contains(sender.titleLabel!.text!) {
                selectedTypes.remove(at: selectedTypes.firstIndex(of: sender.titleLabel!.text!)!)
            }
        }
    }
    
    @objc func didDismiss(_ sender: UIButton) {
        //let vc = PokedexVC()
        //PokedexVC.selectedTypes = selectedTypes
        
        if self.delegate != nil  {
            self.delegate?.sendSelectedTypes(data: selectedTypes)
            dismiss(animated: true, completion: nil)
        }
                
    }
}
