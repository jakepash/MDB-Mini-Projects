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
    var longestStreak: Int!
	var lastThreeQuestions: [[String]]!
	
	
	let streakLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 20, weight: .medium)
		return label
	}()
	
	
	let questionsLabels: [UILabel] = {
		// Creates 4 buttons, each representing a choice.
		// Use ..< or ... notation to create an iterable range
		// with step of 1. You can manually create these using the
		// stride() method.
		return (0..<3).map { index in
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.textAlignment = .center
			label.font = .systemFont(ofSize: 14, weight: .medium)
			label.tag = index
			return label
		}
		
	}()
	
	let backButton: UIButton = {
		let button = UIButton()
		button.setTitle("Back", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	
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
    var dataWeNeedExample2: String
    init(data: String) {
        dataWeNeedExample2 = data
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: >> Your Code Here <<
		
		streakLabel.text = ("Longest Streak: \(longestStreak!)")
		for i in 0..<(min(lastThreeQuestions.count, 3)) {
			let label = questionsLabels[i]
			let question = lastThreeQuestions[lastThreeQuestions.count-1-i]
			label.text = question[0]
			if question[1] == "correct" {
				label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
			} else {
				label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
			}
			
		}
		
		let labelStackView = UIStackView(arrangedSubviews: questionsLabels)
		labelStackView.axis = NSLayoutConstraint.Axis.vertical
		labelStackView.distribution = UIStackView.Distribution.equalSpacing
		labelStackView.alignment = UIStackView.Alignment.center
		labelStackView.spacing = 16.0

		labelStackView.translatesAutoresizingMaskIntoConstraints = false
		
		backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)

		view.addSubview(labelStackView)
		view.addSubview(streakLabel)
		view.addSubview(backButton)
		
		
		NSLayoutConstraint.activate([
			streakLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			streakLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
			streakLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
			
//			pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//			pauseButton.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 20),
//			pauseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
			backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			backButton.trailingAnchor.constraint(equalTo: streakLabel.leadingAnchor, constant: -20),
//
//
//			imageView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20),
//			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
//			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
//			imageView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
//
			labelStackView.topAnchor.constraint(equalTo: streakLabel.bottomAnchor, constant: 50),
			labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			

			
		])
    }
	
	@objc func didTapBack(_ sender: UIButton) {
		
		let vc = MainVC()
		vc.modalPresentationStyle = .fullScreen
//		vc.view.backgroundColor = .white
		present(vc, animated: true, completion: nil)
	}
}


