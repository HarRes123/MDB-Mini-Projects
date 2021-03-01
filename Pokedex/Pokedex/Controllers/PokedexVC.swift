//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit

class PokedexVC: UIViewController, SelectedTypesProtocol {
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
    
    var pokemonsToDisplay: [Pokemon] = []
    var pokemonsToDisplayCopy: [Pokemon] = []
    var selectedTypes: [String] = []
    
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
    
    let filtersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Types", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var searchBar: UISearchBar!
    
    func sendSelectedTypes(data: [String]) {
        selectedTypes = data
    }
    
    private func getPokemon() -> [Pokemon] {
        if selectedTypes.count > 0 {
            var filteredPokemons: [Pokemon] = []
            for pokemon in pokemons {
                var stringArray: [String] = []
                for type in pokemon.types {
                    stringArray.append("\(type)")
                }
                if Set(selectedTypes).isSubset(of: Set(stringArray)) {
                    filteredPokemons.append(pokemon)
                }
            }
            return filteredPokemons
        }
        return pokemons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pokemonsToDisplay = getPokemon()
        pokemonsToDisplayCopy = pokemonsToDisplay
        dismissSearch()
    }
    
    private func dismissSearch() {
        searchBar.text = ""
        searchBar.endEditing(true)
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        view.addSubview(gridToggle)
        view.addSubview(filtersButton)
        
        view.backgroundColor = .white
        collectionView.reloadData()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 150, left: 10, bottom: 0, right: 10))
        searchBar = UISearchBar.init(frame: CGRect(x: 10, y: 90, width: collectionView.bounds.width, height: 50))
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        gridToggle.addTarget(self, action: #selector(didTapToggle(_:)), for: .touchUpInside)
        filtersButton.addTarget(self, action: #selector(didTapFilters(_:)), for: .touchUpInside)
        
        searchBar.showsCancelButton = true
        
        NSLayoutConstraint.activate([
            gridToggle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridToggle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            filtersButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            filtersButton.heightAnchor.constraint(equalTo: filtersButton.safeAreaLayoutGuide.heightAnchor),
            filtersButton.widthAnchor.constraint(equalTo: filtersButton.safeAreaLayoutGuide.widthAnchor)
        ])
    }
    
    @objc func didTapToggle(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
    @objc func didTapFilters(_ sender: UIButton) {
        let vc = FiltersVC()
        vc.modalPresentationStyle = .fullScreen
        vc.selectedTypes = selectedTypes
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}

extension PokedexVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonsToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = pokemonsToDisplay[indexPath.item]
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
        
        let currPokemon = pokemonsToDisplay[indexPath.row]
        let vc = PokeInfoVC()
        vc.pokemon = currPokemon
        present(vc, animated: true, completion: nil)
    }
}

extension PokedexVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pokemonsToDisplay = pokemonsToDisplay.filter({item in
            
            item.name.localizedCaseInsensitiveContains(searchText)
  
        })
        
        if searchText == "" {
            pokemonsToDisplay = pokemonsToDisplayCopy
        }
        
        collectionView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissSearch()
        pokemonsToDisplay = pokemonsToDisplayCopy
    }
}
