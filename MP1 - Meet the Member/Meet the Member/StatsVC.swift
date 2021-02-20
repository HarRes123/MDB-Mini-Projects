//
//  StatsVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import UIKit

class StatsVC: UIViewController {
    
    // MARK: STEP 13: StatsVC Data
    // When we are navigating between VCs (e.g MainVC -> StatsVC),
    // since MainVC doesn't directly share its instance properties
    // with other VCs, we often need a mechanism of transferring data
    // between view controllers. There are many ways to achieve
    // this, and I will show you the two most common ones today. After
    // carefully reading these two patterns, pick one and implement
    // the data transferring for StatsVC.
    
    // Method 1: Implicit Unwrapped Instance Property
    //var lastThreeAnswers: String!
    //
    // Check didTapStats in MainVC.swift on how to use it.
    //
    // Explaination: This method is fairly straightforward: you
    // declared a property, which will then be populated after
    // the VC is instantiated. As long as you remember to
    // populate it after each instantiation, the implicit forced
    // unwrap will not result in a crash.
    //
    // Pros: Easy, no boilerplate required
    //
    // Cons: Poor readability. Imagine if another developer wants to
    // use this class, unless it's been well-documented, they would
    // have no idea that this variable needs to be populated.
    
    // Method 2: Custom initializer
    var lastThreeAnswers: [String]
    init(data: [String]) {
        lastThreeAnswers = data.reversed()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    // Check didTapStats in MainVC.swift on how to use it.
    //
    // Explaination: This method creates a custom initializer which
    // takes in the required data. This pattern results in a cleaner
    // initialization and is more readable. Compared with method 1
    // which first initialize the data to nil then populate, in this
    // method the data is directly initialized in the init so there's
    // no need for unwrapping of any kind.
    //
    // Pros: Clean. Null safe.
    //
    // Cons: Doesn't work with interface builder (storyboard)
    
    // MARK: >> Your Code Here <<
    
    // MARK: STEP 14: StatsVC UI
    // You know the drill. Initialize the UI components, add subviews,
    // and create contraints.
    //
    // Note: You cannot use self inside these closures because they
    // happens before the instance is fully initialized. If you want
    // to use self, do it in viewDidLoad.
    
    // MARK: >> Your Code Here <<
    
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
    
    let longestStreak: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Longest Streak: \(UserDefaults.standard.object(forKey: "streak")!)"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let answersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Previous Answers: "
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 27, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(lastThreeAnswers)
        print(UserDefaults.standard.integer(forKey: "streak"))
        view.backgroundColor = .white
        // MARK: >> Your Code Here <<
        
        answersLabel.text! += lastThreeAnswers.joined(separator: ",\n")
        
        view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        dismissButton.addTarget(self, action: #selector(didDismiss(_:)), for: .touchUpInside)
        
        view.addSubview(answersLabel)
        NSLayoutConstraint.activate([
            answersLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -100),
            answersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            answersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(longestStreak)
        NSLayoutConstraint.activate([
            longestStreak.bottomAnchor.constraint(equalTo: answersLabel.safeAreaLayoutGuide.bottomAnchor, constant: 75),
            longestStreak.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            longestStreak.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    @objc func didDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
