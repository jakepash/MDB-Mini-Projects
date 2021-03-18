//
//  FeedVC.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import UIKit
import Kingfisher

class FeedVC: UIViewController {
    
    private let signOutButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn.backgroundColor = .primary
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .medium))
        btn.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 50
        
        return btn
    }()
	
	private let eventCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 30
		layout.minimumInteritemSpacing = 30
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	var events: [Event] = []
    
    override func viewDidLoad() {
		view.addSubview(eventCollectionView)
		eventCollectionView.dataSource = self
		eventCollectionView.delegate = self
		eventCollectionView.backgroundColor = .white
		
		NSLayoutConstraint.activate([
			eventCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
			eventCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			eventCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			eventCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(didTapSignOut(_:)))
//		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

		
		FIRDatabaseRequest().getEvents { (documents) in
			self.events = []
			for document in documents {
				guard let event = try? document.data(as: Event.self) else {
					print("FAILURE")
					return
				}
				self.events.append(event)
				self.eventCollectionView.reloadData()
				
			}
		}
		
		
    }
    
    @objc func didTapSignOut(_ sender: UIButton) {
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
	

}

extension FeedVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return events.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let event = events[indexPath.item]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
		
		FIRDatabaseRequest().getImage(event.photoURL, completion: { (image) in
			cell.imageView.image = image
			cell.isLoading(isloading: false)
		})
		cell.titleLabel.text = event.name
		FIRDatabaseRequest().getUsername(event.creator, completion: { (fullname) in
			cell.authorLabel.text = "by \(fullname)"
		})
		cell.rsvpLabel.text = "\(event.rsvpUsers.count) already RSVPed"
		cell.eventDescription = event.description
		cell.event = event
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("\(indexPath.row) selected")
		let vc = EventDetailViewController()
		let collectionView = collectionView.cellForItem(at: indexPath) as! FeedCollectionViewCell
		vc.eventName = collectionView.titleLabel.text
		vc.creatorName = collectionView.authorLabel.text
		vc.numberRSVPed = collectionView.rsvpLabel.text
		vc.image = collectionView.imageView.image
		vc.eventDescription = collectionView.eventDescription
		vc.event = collectionView.event
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 300, height: 200)
	}

}
