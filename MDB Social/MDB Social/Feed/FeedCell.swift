//
//  FeedCell.swift
//  MDB Social
//
//  Created by Harrison Resnick on 3/7/21.
//

import Foundation
import UIKit
import FirebaseStorage

class FeedCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = String(describing: FeedCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let event: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let member: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rsvp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cellContents: Event? {
        didSet {
            
            let completion: (UIImage) -> Void = { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let reference =  Storage.storage().reference(forURL: self.cellContents!.photoURL)
                reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        completion(UIImage(data: data!)!)
                    }
                }

            }
            
            event.text = cellContents?.name
            rsvp.text = "RSVP Count: \(cellContents?.rsvpUsers.count ?? 0)"
            
            let reference = FIRDatabaseRequest.shared.db.collection("users").document(cellContents!.creator)
            reference.getDocument(completion: { (snapshot, err) in
                if let err = err {
                    print(err)
                } else {
                    guard let user = try? snapshot?.data(as: User.self) else {
                        print("Could not get user")
                        return
                    }
                    self.member.text = user.fullname
                }
            })
        }
    }
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cyan

        contentView.addSubview(imageView)
        contentView.addSubview(event)
        contentView.addSubview(member)
        contentView.addSubview(rsvp)

        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor


        NSLayoutConstraint.activate([
            event.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            event.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            member.topAnchor.constraint(equalTo: event.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            member.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            rsvp.topAnchor.constraint(equalTo: member.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            rsvp.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
