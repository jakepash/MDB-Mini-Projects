//
//  EventDetailViewController.swift
//  MDB Social
//
//  Created by Jacob Pashman on 3/14/21.
//

import UIKit
import Firebase

class EventDetailViewController: UIViewController {
	
	var event: Event!
	var eventName: String!
	var eventDescription: String!
	var creatorName: String!
	var numberRSVPed: String!
	var image: UIImage!
	
	let userUID = Auth.auth().currentUser!.uid

	let label: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		
		return label
	}()
	
	let imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		return imageView
	}()
	
	private let rsvpButton: LoadingButton = {
		let btn = LoadingButton()
		btn.layer.backgroundColor = UIColor.primary.cgColor
		btn.setTitle("RSVP", for: .normal)
		btn.setTitleColor(.white, for: .normal)
		btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
		btn.isUserInteractionEnabled = true
		
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = .white
		view.addSubview(label)
		view.addSubview(imageView)
		view.addSubview(rsvpButton)
		imageView.image = image

        // Do any additional setup after loading the view.
		label.text = "\(eventName ?? "")\n \n \(eventDescription ?? "")\n \n \(creatorName ?? "")\n \n \(numberRSVPed ?? "")"
		
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
			label.topAnchor.constraint(equalTo: view.centerYAnchor),
			label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			rsvpButton.topAnchor.constraint(equalTo: label.bottomAnchor),
			rsvpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//			rsvpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//			rsvpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
		])
		
		
		
		if userUID == event.creator {
			rsvpButton.setTitle("Delete Event", for: .normal)
			rsvpButton.layer.backgroundColor = UIColor.red.cgColor
			rsvpButton.addTarget(self, action: #selector(didTapDelete(_:)), for: .touchUpInside)
		} else if event.rsvpUsers.contains(userUID) {
			rsvpButton.setTitle("Cancel RSVP", for: .normal)
			rsvpButton.layer.backgroundColor = UIColor.red.cgColor
			rsvpButton.addTarget(self, action: #selector(didTapUnRSVP(_:)), for: .touchUpInside)
		} else {
			rsvpButton.layer.backgroundColor = UIColor.primary.cgColor
			rsvpButton.setTitle("RSVP", for: .normal)
			rsvpButton.addTarget(self, action: #selector(didTapRSVP(_:)), for: .touchUpInside)
		}
		
    }
	
	@objc func didTapDelete(_ sender: UIButton) {
		FIRDatabaseRequest().deleteEvent(eventID: event.id!, completion: {
			self.navigationController?.popViewController(animated: true)
		})
	}
	
	@objc func didTapRSVP(_ sender: UIButton) {
		print("RSVP tapped!")
		event.rsvpUsers.append(userUID)
		FIRDatabaseRequest().setEvent(event, completion: { [self] in
			label.text = "\(eventName ?? "") \n \n \(eventDescription ?? "")  \n \n \(creatorName ?? "") \n \n \(event.rsvpUsers.count) already RSVPed"
			rsvpButton.setTitle("Cancel RSVP", for: .normal)
			rsvpButton.layer.backgroundColor = UIColor.red.cgColor
			rsvpButton.addTarget(self, action: #selector(didTapUnRSVP(_:)), for: .touchUpInside)
		})
		
		

	}
	
	@objc func didTapUnRSVP(_ sender: UIButton) {
		if let index = event.rsvpUsers.firstIndex(of: userUID) {
			event.rsvpUsers.remove(at: index)
		}
		FIRDatabaseRequest().setEvent(event, completion: { [self] in
			label.text = "\(eventName ?? "") \n \n \(eventDescription ?? "")  \n \n \(creatorName ?? "") \n \n \(event.rsvpUsers.count) already RSVPed"
			rsvpButton.setTitle("RSVP", for: .normal)
			rsvpButton.layer.backgroundColor = UIColor.primary.cgColor
			rsvpButton.addTarget(self, action: #selector(didTapRSVP(_:)), for: .touchUpInside)
		})

	}
	
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
