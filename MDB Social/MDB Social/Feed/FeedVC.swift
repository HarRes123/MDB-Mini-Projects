//
//  FeedVC.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit
import FirebaseFirestore

class FeedVC: UIViewController {
    
    var events: [Event]?
    
    private let signOutButton: UIButton = {
       let btn = UIButton()
       btn.backgroundColor = .primary
       btn.setImage(UIImage(systemName: "xmark"), for: .normal)
       let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
       btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
       btn.tintColor = .white
       btn.layer.cornerRadius = 25
       btn.translatesAutoresizingMaskIntoConstraints = false
       return btn
   }()
    
    private let createButton: UIButton = {
       let btn = UIButton()
       btn.backgroundColor = .primary
       btn.setImage(UIImage(systemName: "plus"), for: .normal)
       let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
       btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
       btn.tintColor = .white
       btn.layer.cornerRadius = 25
       btn.translatesAutoresizingMaskIntoConstraints = false
       return btn
   }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
        
        return collectionView
    }()
    
    func update(newEvents: [Event]) {
        events = newEvents
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        events = FIRDatabaseRequest.shared.getEvents(vc: self)
        view.addSubview(collectionView)
        view.addSubview(signOutButton)
        view.addSubview(createButton)
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate(_:)), for: .touchUpInside)
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 175, left: 10, bottom: 0, right: 10))
        
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            signOutButton.widthAnchor.constraint(equalToConstant: 50),
            signOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            createButton.widthAnchor.constraint(equalToConstant: 50),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
        FIRAuthProvider.shared.signOut {
            guard let window = UIApplication.shared
                    .windows.filter({ $0.isKeyWindow }).first else { return }
            let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController()
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
    @objc func didTapCreate(_ sender: UIButton) {
        let vc = CreateEntryVC()
        present(vc, animated: true, completion: nil)
    }
}

extension FeedVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let contents = events?[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier, for: indexPath) as! FeedCell
        cell.cellContents = contents
        return cell
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 125)
    }
}
