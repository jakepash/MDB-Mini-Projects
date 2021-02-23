//
//  MainVC.swift
//  Meet the Member
//
//  Created by Michael Lin on 1/18/21.
//

import Foundation
import UIKit

class MainVC: UIViewController {
    
    // Create a property for our timer, we will initialize it in viewDidLoad
    var timer: Timer?
	var timePassed = 0
	var score = 0
	var paused = false
	var streak = 0
	var longestStreak = 0
	var lastThreeQuestions = [[String]]()
    
    // MARK: STEP 8: UI Customization
    // Customize your imageView and buttons. Run the app to see how they look.
    
    let imageView: UIImageView = {
        let view = UIImageView()
        
        // MARK: >> Your Code Here <<
<<<<<<< HEAD
		view.contentMode = .scaleAspectFill
		view.clipsToBounds = true
		view.layer.cornerRadius = 10
=======
    
>>>>>>> 7adce702e2b3a9c5809503e234c4c1b3da074c84
        view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .blue
//		view.frame.size = CGSize(width: 200, height: 300)
        return view
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
            
            // MARK: >> Your Code Here <<
			button.setTitleColor(.blue, for: .normal)
			button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
			button.layer.cornerRadius = 10
			
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }
        
    }()
	
	let scoreLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 27, weight: .medium)

		return label
	}()
	
	let pauseButton: UIButton = {
		let button = UIButton()
		button.setTitle("Pause", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	let statsButton: UIButton = {
		let button = UIButton()
		button.setTitle("Stats", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	let progressView: UIProgressView = {
		let progressView = UIProgressView()
		progressView.setProgress(0.5, animated: true)
		progressView.trackTintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
		progressView.tintColor = .blue
		progressView.translatesAutoresizingMaskIntoConstraints = false
		progressView.setProgress(1, animated: false)
		
		return progressView
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
		        
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
		view.addSubview(imageView)
		
		
		let buttonStackView = UIStackView(arrangedSubviews: buttons)
		buttonStackView.axis = NSLayoutConstraint.Axis.vertical
		buttonStackView.distribution = UIStackView.Distribution.equalSpacing
		buttonStackView.alignment = UIStackView.Alignment.center
		buttonStackView.spacing = 16.0

		buttonStackView.translatesAutoresizingMaskIntoConstraints = false
		
		updateScore()
		view.addSubview(scoreLabel)
		view.addSubview(statsButton)
		view.addSubview(pauseButton)
		view.addSubview(progressView)

		view.addSubview(buttonStackView)
		NSLayoutConstraint.activate([
			scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
			scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
			
			pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			pauseButton.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 20),
			pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			statsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			statsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			statsButton.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -20),
			
			progressView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
			progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			
			imageView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 50),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			imageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
			
			buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
			buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			
			

			
		])
		
        getNextQuestion()
		

		
        
        // MARK: STEP 10: Adding Callback to the Buttons
        // Use addTarget to connect the didTapAnswer function to the four
        // buttons touchUpInside event.
        //
        // Challenge: Try not to use four separate statements. There's a
        // cleaner way to do this, see if you can figure it out.
        
        // MARK: >> Your Code Here <<
		for i in 0...buttons.count-1 {
			buttons[i].addTarget(self, action: #selector(didTapAnswer(_:)), for: .touchUpInside)
		}
		
		pauseButton.addTarget(self, action: #selector(didTapPause(_:)), for: .touchUpInside)
		statsButton.addTarget(self, action: #selector(didTapStats(_:)), for: .touchUpInside)
        
        
        // MARK: STEP 12: Stats Button
        // Follow instructions at :49
        
        // MARK: >> Your Code Here <<
    }
    
    // What's the difference between viewDidLoad() and
    // viewWillAppear()? What about viewDidAppear()?
    override func viewWillAppear(_ animated: Bool) {
        // MARK: STEP 15: Resume Game
        // Restart the timer when view reappear.
        
        // MARK: >> Your Code Here <<
		paused = true
		pause()
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
		guard let question = QuestionProvider().getNextQuestion() else {return}
        
        // MARK: STEP 6: Data Population
        // Populate the imageView and buttons using the question object we obtained
        // above.
        
        // MARK: >> Your Code Here <<
		imageView.image = question.image
		for i in 0...buttons.count-1 {
			buttons[i].setTitle(question.choices[i], for: .normal)
			if question.choices[i] == question.answer {
				buttons[i].tag = 1
			} else {
				buttons[i].tag = 0
			}
		}
		
		
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
		
		if !paused {
			if timePassed == 5 {
				streak = 0
				getNextQuestion()
				timePassed = 0
				progressView.setProgress(1, animated: false)
			} else {
				timePassed += 1
				progressView.setProgress(1-Float(timePassed)/5, animated: true)
			}
		}

		
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
		
		if sender.tag == 1 {
			sender.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
			score += 1
			streak += 1
			if streak > longestStreak {
				longestStreak = streak
			}
			updateScore()
			lastThreeQuestions.append([sender.title(for: .normal)!, "correct"])
		} else {
			sender.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
			streak = 0
			lastThreeQuestions.append([sender.title(for: .normal)!, "false"])	
		}
		
		self.timePassed = -2
		_ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
			self.getNextQuestion()
			sender.setTitleColor(.blue, for: .normal)
		}
		
    }
	
	
    
    @objc func didTapStats(_ sender: UIButton) {
        
        let vc = StatsVC(data: "Hello")
		
        
        vc.longestStreak = longestStreak
		vc.lastThreeQuestions = lastThreeQuestions
        
        vc.modalPresentationStyle = .fullScreen
        
        // MARK: STEP 13: StatsVC Data
        // Follow instructions in StatsVC. You also need to invalidate
        // the timer instance to pause game before going to StatsVC.
        
        // MARK: >> Your Code Here <<
		paused = false
		pause()
        
		vc.modalPresentationStyle = .fullScreen
		vc.view.backgroundColor = .white
        present(vc, animated: true, completion: nil)
    }
	
	@objc func didTapPause(_ sender: UIButton) {
		pause()
	}
	
	func pause() {
		if paused {
			paused = false
			pauseButton.setTitle("Pause", for: .normal)
			score = 0
			updateScore()
			timePassed = 0
		} else {
			paused = true
			pauseButton.setTitle("Resume", for: .normal)
			progressView.setProgress(1, animated: true)
		}
	}
	
	func updateScore() {
		scoreLabel.text = "Score: \(score)"
	}
    
    // MARK: STEP 16:
    // Read the spec again and run the app. Did you cover everything
    // mentioned in it? Play around it for a bit, see if you can
    // uncover any bug. Is there anything else you want to add?
}
