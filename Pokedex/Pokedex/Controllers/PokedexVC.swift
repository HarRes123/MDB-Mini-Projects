//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController {
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PokeCell.self, forCellWithReuseIdentifier: PokeCell.reuseIdentifier)
        return collectionView
    }()
    
    let gridToggle: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "rectangle.grid.2x2"), for: .normal)
        button.setImage(UIImage(systemName: "rectangle.grid.1x2"), for: .selected)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        button.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 100, left: 10, bottom: 0, right: 10))
        
        view.addSubview(gridToggle)
        NSLayoutConstraint.activate([
            gridToggle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        gridToggle.addTarget(self, action: #selector(didTapToggle(_:)), for: .touchUpInside)
        
    }
    @objc func didTapToggle(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        collectionView.performBatchUpdates(nil, completion: nil)
    }
}

extension PokedexVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = pokemons[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.reuseIdentifier, for: indexPath) as! PokeCell
        cell.cellContents = item
        return cell
    }
}

extension PokedexVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !gridToggle.isSelected {
            return CGSize(width: view.frame.width - 50, height: view.frame.width / 3)
        } else {
            return CGSize(width: view.frame.width / 2 - 25, height: view.frame.width / 3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currPokemon = pokemons[indexPath.row]
        let vc = PokeInfoVC()
        vc.pokemon = currPokemon
        present(vc, animated: true, completion: nil)
    }
}
