//
//  ViewController.swift
//  WeatherDB
//
//  Created by Michael Lin on 3/20/21.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
        
    var locations: [CLLocation] = [] {
        didSet {
            let encoded = try! NSKeyedArchiver.archivedData(withRootObject: locations, requiringSecureCoding: true)
            UserDefaults.standard.set(encoded, forKey: "locations")
            collectionView.reloadData()
        }
    }
        
    var currLocation: CLLocation? {
        
        didSet {
            if locations.count > 0 {
                locations[0] = currLocation!
            } else {
                locations.append(currLocation!)
            }
            collectionView.reloadData()
        }
    }
    
    private let addButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        btn.backgroundColor = .systemGreen
        btn.setTitle("Add", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.layer.cornerRadius = 15
        btn.layer.borderWidth = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    let weatherLbl = UILabel()
    
    func addLocation(location: CLLocation) {
        locations.append(location)
    }
    
    @objc func locationChange() {
        self.currLocation = LocationManager.shared.location!
    }
    
    @objc func addClicked(_ sender: UIButton) {
          let autocompleteController = GMSAutocompleteViewController()
          autocompleteController.delegate = self

          let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))
          autocompleteController.placeFields = fields

          let filter = GMSAutocompleteFilter()
          filter.type = .address
          autocompleteController.autocompleteFilter = filter

          present(autocompleteController, animated: true, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        changeBoarder()
    }
    
    private func changeBoarder() {
        if self.traitCollection.userInterfaceStyle == .light {
            addButton.layer.borderColor = UIColor.black.cgColor
        } else {
            addButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeBoarder()
        
        if let decoded = UserDefaults.standard.object(forKey: "locations") as? Data {
            locations = try! NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, CLLocation.self], from: decoded) as! [CLLocation]
        }
        
        let positionChangeName = Notification.Name(rawValue: "locationChange")
        NotificationCenter.default.addObserver(
            self, selector: #selector(locationChange),
            name: positionChangeName, object: nil
        )
        
        view.addSubview(collectionView)
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
    

        collectionView.frame = view.bounds.inset(by: UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0))
        
        collectionView.allowsSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            addButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -25),
            addButton.widthAnchor.constraint(equalToConstant: 75)
        ])

    }

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    @objc func deleteCell(sender: UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        if i != 0 {
            locations.remove(at: i)
        } else {
            switch CLLocationManager().authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    locations.remove(at: i)
                default:
                    let alert = UIAlertController(title: "This Cell Cannot be Deleted", message: "You may not delete the weather at your current location", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! WeatherCollectionViewCell
        let location  = locations[indexPath.item]
        cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteButton.addTarget(self, action: #selector(deleteCell), for: .touchUpInside)
        
        WeatherRequest.shared.weather(at: location, completion: { result in
        switch result {
            case .success(let weather):
                cell.weather = weather
                return
            case .failure(let error):
                print(error)
                return
            }
        })
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width - 50, height: 250)
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

        let coordinates = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        addLocation(location: coordinates)
        dismiss(animated: true, completion: nil)

    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

}
