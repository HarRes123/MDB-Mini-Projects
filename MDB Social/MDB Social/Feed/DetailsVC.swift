//
//  DetailsVC.swift
//  MDB Social
//
//  Created by Harrison Resnick on 3/12/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import UIKit

class DetailsVC: UIViewController {
    var selectedEvent: Event? {
        didSet {
            if (selectedEvent?.creator == FIRAuthProvider.shared.currentUser?.uid) {
               isCreator = true
            }
            
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
    
    let dismissButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Dismiss", for: .normal)
        button.backgroundColor = .white

        return button
    }()
    
    private var rsvpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .quaternarySystemFill
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var deleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .systemRed
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var isCreator: Bool = false
    private var didRSVP: Bool?
            
    override func viewDidLoad() {
        
        didRSVP = selectedEvent?.rsvpUsers.contains((FIRAuthProvider.shared.currentUser?.uid)!)
        
        if isCreator {
            deleteButton.isHidden = false
        }

        if didRSVP! {
            rsvpButton.setTitle("Cancel RSVP", for: .normal)
        } else {
            rsvpButton.setTitle("RSVP", for: .normal)
        }
        
        view.backgroundColor = #colorLiteral(red: 0.9567814469, green: 0.956869781, blue: 0.9610591531, alpha: 1)
        view.addSubview(stack)
        stack.addArrangedSubview(event)
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(member)
        stack.addArrangedSubview(date)
        stack.addArrangedSubview(desc)
        stack.addArrangedSubview(rsvp)
        stack.addArrangedSubview(rsvpButton)
        view.addSubview(deleteButton)
        view.addSubview(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(didDismiss(_:)), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTapDelete(_:)), for: .touchUpInside)
        rsvpButton.addTarget(self, action: #selector(didTapRsvp(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stack.topAnchor.constraint(equalTo: dismissButton.safeAreaLayoutGuide.bottomAnchor, constant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func didTapRsvp(_ sender: UIButton) {
        let ref = FIRDatabaseRequest.shared.db.collection("events").document(selectedEvent!.id!)
        
        if didRSVP! {
            
            didRSVP = false
            
            for i in 0..<selectedEvent!.rsvpUsers.count {
                if selectedEvent?.rsvpUsers[i] == FIRAuthProvider.shared.currentUser?.uid {
                    ref.updateData(["rsvpUsers": FieldValue.arrayRemove([selectedEvent!.rsvpUsers[i]])]) { error in
                        if let error = error {
                            print(error)
                        }
                    }
                    selectedEvent?.rsvpUsers.remove(at: i)
                    break
                }
            }
            rsvpButton.setTitle("RSVP", for: .normal)
            
        } else {
            print("TEST")
            didRSVP = true
            ref.updateData(["rsvpUsers": FieldValue.arrayUnion([(FIRAuthProvider.shared.currentUser?.uid)!])]) { error in
                if let error = error {
                    print(error)
                }
            }
            selectedEvent?.rsvpUsers.append((FIRAuthProvider.shared.currentUser?.uid)!)
            rsvpButton.setTitle("Cancel RSVP", for: .normal)
        }
    }
    
    @objc func didTapDelete(_ sender: UIButton) {
        print("DELETE")
        let ref = FIRDatabaseRequest.shared.db.collection("events").document(selectedEvent!.id!)
        ref.delete() { error in
            if let error = error {
                print(error)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    
    }
}
