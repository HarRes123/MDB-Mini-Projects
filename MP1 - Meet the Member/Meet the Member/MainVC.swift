//
//  MainVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a timer, call timerCallback every one second.
  //  let timer: Timer? = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
    var progressTimer: Timer?
    var progressViewTimer: Timer?
    var correctAnswer: String?
    var currentScore = 0
    var streak = 0
    var imageHeightConstraint: NSLayoutConstraint?
    var imageWidthConstraint: NSLayoutConstraint?
    var tappedButton: UIButton?
    var lastThreeAnswers: [String] = []
    
    // MARK: STEP 8: UI Customization
    // Customize your imageView and buttons. Run the app to see how they look.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progressTintColor = .blue
        view.progress = 1.0
        return view
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Score: 0"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buttons: [UIButton] = {
        // Creates 4 buttons, each representing a choice.
        // Use ..< or ... notation to create an iterable range
        // with step of 1. You can manually create these using the
        // stride() method.
        return (0..<4).map { index in
            let button = UIButton()

            // Tag the button its index
            button.tag = index
                        
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15)
            button.backgroundColor = .systemYellow
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.titleLabel?.minimumScaleFactor = 0.5
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
            return button
        }
        
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Resume", for: .selected)
        button.setTitle("Pause", for: .normal)
        button.backgroundColor = .systemPink

        return button
    }()
    
    let statsButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stats", for: .normal)
        button.backgroundColor = .cyan

        return button
    }()
    
    // MARK: STEP 12: Stats Button
    // Follow the examples you've learned so far, initialize a
    // stats button used for going to the stats screen, add it
    // as a subview inside the viewDidLoad and set up the
    // constraints. Finally, connect the button's with the @objc
    // function didTapStats.
    
    // MARK: >> Your Code Here <<
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        // Create a timer that calls timerCallback() every one second
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        
        // If you don't like the default presentation style,
        // you can change it to full screen too! This way you
        // will have manually to call
        // dismiss(animated: true, completion: nil) in order
        // to go back.
        //
        // modalPresentationStyle = .fullScreen
        
        // MARK: STEP 7: Adding Subviews and Constraints
        // Add imageViews and buttons to the root view. Create constraints
        // for the layout. Then run the app with ⌘+r. You should see the image
        // for the first question as well as the four options.
        
        // MARK: >> Your Code Here <<
        
        
        for i in 0...3 {
            view.addSubview(buttons[i])
            buttons[i].heightAnchor.constraint(equalToConstant: 50).isActive = true
            buttons[i].widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
        }
        NSLayoutConstraint.activate([
            buttons[0].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -185),
            buttons[0].leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            buttons[1].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -185),
            buttons[1].trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            buttons[2].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85),
            buttons[2].leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            buttons[3].bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -85),
            buttons[3].trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -75),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        
        ])
        view.addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scoreLabel.heightAnchor.constraint(equalToConstant: 20),
            scoreLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 82),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25)
        ])
        
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            pauseButton.heightAnchor.constraint(equalToConstant: 40),
            pauseButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        view.addSubview(statsButton)
        NSLayoutConstraint.activate([
            statsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            statsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            statsButton.heightAnchor.constraint(equalToConstant: 40),
            statsButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        // MARK: STEP 10: Adding Callback to the Buttons
        // Use addTarget to connect the didTapAnswer function to the four
        // buttons touchUpInside event.
        //
        // Challenge: Try not to use four separate statements. There's a
        // cleaner way to do this, see if you can figure it out.
        
        // MARK: >> Your Code Here <<
        for button in buttons {
            button.addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
        }
        
        pauseButton.addTarget(self, action: #selector(pressedPause(_:)), for: .touchUpInside)
        statsButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        getNextQuestion()
        
        // MARK: STEP 12: Stats Button
        // Follow instructions at :49
        
        // MARK: >> Your Code Here <<
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if !pauseButton.isSelected {
            pressedPause(pauseButton)
        }
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 15: Resume Game
        // Restart the timer when view reappear.
        timer?.invalidate()
        // MARK: >> Your Code Here <<
    }
    
    func getNextQuestion() {
        // MARK: STEP 5: Connecting to the Data Model
        // Read the QuestionProvider class in Utils.swift. Get an instance of
        // QuestionProvider.Question and use a *guard let* statement to conditionally
        // assign it to a constant named question. Return if the guard let
        // condition failed.
        //
        // After you are done, take a look at what's in the
        // QuestionProvider.Question type. You will need that for the
        // following steps.
        // MARK: >> Your Code Here <<
        guard let question = QuestionProvider.shared.getNextQuestion() else { return }
        correctAnswer = question.answer
        
        print(correctAnswer!)
        
        progressView.progress = 1.0
        // MARK: STEP 6: Data Population
        // Populate the imageView and buttons using the question object we obtained
        // above.
        
        // MARK: >> Your Code Here <<
        imageHeightConstraint?.isActive = false
        imageWidthConstraint?.isActive = false
        
        imageView.image = question.image
        let ratio = (imageView.image?.size.width)! / (imageView.image?.size.height)!
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: view.frame.width - 150)
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: ratio * (view.frame.width - 150))
        
        imageHeightConstraint?.isActive = true
        imageWidthConstraint?.isActive = true

        
        for i in 0...3 {
            buttons[i].setTitle(question.choices[i], for: .normal)
        }
        progressTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(progressTimerCallback), userInfo: nil, repeats: true)
        progressViewTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(progressViewTimerCallBack), userInfo: nil, repeats: true)
        
    }
    private func changeButtonState() {
        for button in buttons {
            button.isEnabled = !button.isEnabled
        }
    }
    
    private func appendLastThree() {
        if lastThreeAnswers.count == 3 {
            lastThreeAnswers.remove(at: 0)
        }
        lastThreeAnswers.append(correctAnswer!)
    }
    
    // This function will be called every one second
    @objc func timerCallback() {
        // MARK: STEP 11: Timer's Logic
        // Complete the callback for the one-second timer. Add instance
        // properties and/or methods to the class if necessary. Again,
        // the instruction here is intentionally vague, so read the spec
        // and take some time to plan. you may need
        // to come back and rework this step later on.
        // MARK: >> Your Code Here <<
        timer?.invalidate()
        progressTimer?.invalidate()
        tappedButton?.backgroundColor = .systemYellow
        changeButtonState()
        pauseButton.isEnabled = true
        getNextQuestion()
    }
    
    @objc func progressViewTimerCallBack() {
        progressView.progress -= 0.2
    }
    
    @objc func progressTimerCallback() {
        progressView.progress = 0.0
        progressViewTimer?.invalidate()
        progressTimer?.invalidate()
        timer?.invalidate()
        streak = 0
        for button in buttons {
            if button.titleLabel?.text == correctAnswer {
                tappedButton = button
            }
        }
        changeButtonState()
        pauseButton.isEnabled = false
        appendLastThree()
        tappedButton?.backgroundColor = .green
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
                
    }
    
    
    @objc func didTapAnswer(_ sender: UIButton) {
        // MARK: STEP 9: Buttons' Logic
        // Add logic for the 4 buttons. Take some time to plan what
        // you are gonna write. The 4 buttons should be able to share
        // the same callback. Add instance properties and/or methods
        // to the class if necessary. The instruction here is
        // intentionally vague as I'd like you to decide what you
        // have to do based on the spec. You may need to come back
        // and rework this step later on.
        //
        // Hint: You can use `sender.tag` to identify which button is tapped
        
        // MARK: >> Your Code Here <<
        timer?.invalidate()
        progressViewTimer?.invalidate()
        progressTimer?.invalidate()
        tappedButton = buttons[sender.tag]
        if tappedButton?.titleLabel?.text == correctAnswer {
            print("correct")
            tappedButton?.backgroundColor = .green
            currentScore += 1
            streak += 1
            if streak > UserDefaults.standard.integer(forKey: "streak") {
                UserDefaults.standard.set(streak, forKey: "streak")
            }

        } else {
            streak = 0
            print("incorrect")
            tappedButton?.backgroundColor = .red
        }
        appendLastThree()
        changeButtonState()
        pauseButton.isEnabled = false
        scoreLabel.text = "Score: \(self.currentScore)"
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    @objc func pressedPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        changeButtonState()
        if sender.isSelected {
            sender.backgroundColor = .systemOrange
            currentScore = 0
            streak = 0
            scoreLabel.text = "Score: \(currentScore)"
            progressTimer?.invalidate()
            progressViewTimer?.invalidate()
            timer?.invalidate()
        } else {
            sender.backgroundColor = .systemPink
            QuestionProvider.shared.reset()
            getNextQuestion()
        }
        
    }
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: lastThreeAnswers)
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 13: StatsVC Data
        // Follow instructions in StatsVC. You also need to invalidate
        // the timer instance to pause game before going to StatsVC.
        
        // MARK: >> Your Code Here <<
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: STEP 16:
    // Read the spec again and run the app. Did you cover everything
    // mentioned in it? Play around it for a bit, see if you can
    // uncover any bug. Is there anything else you want to add?
}
