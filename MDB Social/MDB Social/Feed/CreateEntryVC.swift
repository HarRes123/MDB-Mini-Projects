//
//  CreateEntryVC.swift
//  MDB Social
//
//  Created by Harrison Resnick on 3/12/21.
//

import Foundation
import NotificationBannerSwift
import FirebaseFirestore
import FirebaseStorage

class CreateEntryVC: UIViewController, UINavigationControllerDelegate {

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
        
    }()

    private let nameTextField: AuthTextField = {
        let field = AuthTextField(title: "Name:")
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private let descriptionTextField: AuthTextField = {
        let tf = AuthTextField(title: "Description:")
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let datePicker: UIDatePicker =  {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let imagePicker: UIImagePickerController = {
        let controller = UIImagePickerController()
        return controller
    }()

    private let imagePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select an image", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Event", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .quaternarySystemFill
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    private var selectedImageData: Data?
    private var selectedImageMetadata: Any?
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)

    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .background
      
        dismissButton.addTarget(self, action: #selector(didDismiss(_:)), for: .touchUpInside)
        
        nameTextField.textField.delegate = self
        descriptionTextField.textField.delegate = self
        
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            stack.topAnchor.constraint(equalTo: dismissButton.safeAreaLayoutGuide.bottomAnchor, constant: 50)
        ])
        
        
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(descriptionTextField)
        stack.addArrangedSubview(datePicker)
        stack.addArrangedSubview(imagePickerButton)
        stack.addArrangedSubview(createEventButton)
       
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 1
        
        imagePickerButton.addTarget(self, action: #selector(didTapSelectImage(_:)), for: .touchUpInside)
       
        imagePicker.delegate = self
       
        createEventButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)
    }
    
    @objc func didTapSelectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            showErrorBanner(withTitle: "Error",subtitle: "No camera found")
    
        }
    }
        
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            showErrorBanner(withTitle: "Error", subtitle: "Please change permissions in settings")
        }
    }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        guard let name = nameTextField.text, name != "" else {
            showErrorBanner(withTitle: "Missing name",
                            subtitle: "Please provide an event name")
            return
        }
        
        guard let description = descriptionTextField.text, description != "" else {
            showErrorBanner(withTitle: "Missing description",
                            subtitle: "Please provide an event description")
            return
        }
        
        if (selectedImageData == nil) {
            showErrorBanner(withTitle: "Missing image",
                            subtitle: "Please select an image")
            return
        }
        
        if (description.count > 140) {
            showErrorBanner(withTitle: "Event description over 140 characters",
                            subtitle: "Please enter fewer than 140 characters")
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        let currID: UserID = FIRAuthProvider.shared.currentUser!.uid ?? ""

        let ref = Storage.storage().reference().child("\(selectedImageData!.hashValue)" + ".jpeg")

        ref.putData(selectedImageData!, metadata: metaData) { (metadata, error) in
            ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print(error!)
                    return
                }
            let event: Event = Event(name: name, description: description, photoURL: downloadURL.relativeString, startTimeStamp: Timestamp(date: self.datePicker.date), creator: currID, rsvpUsers: [])
            FIRDatabaseRequest.shared.db.collection("events").document(event.id!)
            FIRDatabaseRequest.shared.setEvent(event, completion: {})
                
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
    
    @objc func didDismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension CreateEntryVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImageData = image.jpegData(compressionQuality: 0.1)
            selectedImageMetadata = info[.mediaMetadata]
        }
        //selectedImageMetadata = info[.mediaMetadata]
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension CreateEntryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
