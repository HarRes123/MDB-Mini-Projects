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
        let signOutButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapSignOut(_:)))
        self.navigationItem.leftBarButtonItem = signOutButton
        
        let createButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapCreate(_:)))
        self.navigationItem.rightBarButtonItem = createButton
        
        self.navigationItem.title = "Feed"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        events = FIRDatabaseRequest.shared.getEvents(vc: self)
        view.addSubview(collectionView)
    
        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: self.navigationController!.navigationBar.frame.size.height, left: 0, bottom: 0, right: 0))
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func didTapSignOut(_ sender: UIBarButtonItem) {
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
    
    @objc func didTapCreate(_ sender: UIBarButtonItem) {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsVC()
        vc.selectedEvent = events?[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 125)
    }
    
}
