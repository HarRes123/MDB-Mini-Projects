//
//  DetailsVC.swift
//  MDB Social
//
//  Created by Harrison Resnick on 3/12/21.
//

import Foundation
import FirebaseStorage
import UIKit

class DetailsVC: UIViewController {
    var selectedEvent: Event? {
        didSet {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            date.text = formatter.string(from: selectedEvent!.startDate)
            desc.text = selectedEvent?.description
            
            let completion: (UIImage) -> Void = { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let reference =  Storage.storage().reference(forURL: self.selectedEvent!.photoURL)
                reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        completion(UIImage(data: data!)!)
                    }
                }

            }
            
            event.text = selectedEvent?.name
            rsvp.text = "RSVP Count: \(selectedEvent?.rsvpUsers.count ?? 0)"
            
            let reference = FIRDatabaseRequest.shared.db.collection("users").document(selectedEvent!.creator)
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
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let event: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let member: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rsvp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var desc: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var date: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
            
    override func viewDidLoad() {
        
        view.backgroundColor = #colorLiteral(red: 0.9567814469, green: 0.956869781, blue: 0.9610591531, alpha: 1)
        view.addSubview(stack)
        stack.addArrangedSubview(event)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(member)
        stack.addArrangedSubview(date)
        stack.addArrangedSubview(desc)
        stack.addArrangedSubview(rsvp)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
