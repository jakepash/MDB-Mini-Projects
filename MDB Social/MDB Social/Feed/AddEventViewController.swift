//
//  AddEventViewController.swift
//  MDB Social
//
//  Created by Jacob Pashman on 3/14/21.
//

import UIKit
import ImagePicker
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class AddEventViewController: UIViewController {
	
	private let stack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.distribution = .equalSpacing
		stack.spacing = 15

		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let nameTextField: AuthTextField = {
		let tf = AuthTextField(title: "Event Name:")
		
		tf.translatesAutoresizingMaskIntoConstraints = false
		return tf
	}()
	private let addImageButton: UIButton = {
		let button = UIButton()
		button.setTitle("Add image", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	private let imageView: UIImageView = {
		let iv = UIImageView()
		iv.tintColor = .white
		iv.contentMode = .scaleAspectFit
		iv.clipsToBounds = true
		
		iv.translatesAutoresizingMaskIntoConstraints = false
		return iv
	}()
	
	private let textView: UITextView = {
		let tv = UITextView()
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.text = "Description"
		tv.sizeToFit()
		tv.backgroundColor = .lightGray
		return tv
	}()
	
	private let datePicker: UIDatePicker = {
		let datepicker = UIDatePicker()
		datepicker.datePickerMode = .dateAndTime
		datepicker.date = Date()
	
		return datepicker
	}()
	
	private let pickerController: UIImagePickerController = {
		let pc = UIImagePickerController()
		pc.allowsEditing = false
		pc.sourceType = .photoLibrary
		return pc
	}()
	
	private var imagePickerController = ImagePickerController()
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		textView.delegate = self
		
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(didTapSave(_:)))
		addImageButton.addTarget(self, action: #selector(didTapAddImage(_:)), for: .touchUpInside)
		
		view.addSubview(stack)
		stack.addArrangedSubview(nameTextField)
		stack.addArrangedSubview(addImageButton)
		stack.addArrangedSubview(imageView)
		stack.addArrangedSubview(textView)
		stack.addArrangedSubview(datePicker)
		
		
		NSLayoutConstraint.activate([
			stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.heightAnchor.constraint(equalToConstant: 120.0),
			textView.heightAnchor.constraint(equalToConstant: 80)
		])
		

		let config = Configuration()
		config.allowMultiplePhotoSelection = false
		imagePickerController = ImagePickerController(configuration: config)
		imagePickerController.delegate = self
		
		
    }
	
	@objc func didTapSave(_ sender: UIButton) {
		let photoURL = "gs://mdb-social-sp21.appspot.com/\(UUID().uuidString)"
		let event = Event(name: nameTextField.text!, description: textView.text, photoURL: photoURL, startTimeStamp: Timestamp(date: datePicker.date), creator: Auth.auth().currentUser!.uid, rsvpUsers: [])
		

		if let image = imageView.image {
			FIRDatabaseRequest().uploadImage(image, id:photoURL, completion: {
				print("image uploaded")
				FIRDatabaseRequest().setEvent(event, completion: {
					print("event uploaded")
					self.navigationController?.popViewController(animated: true)
				})
			})
		} else {
			//no image!
			print("no image")
		}
		
		
		

	}
	
	@objc func didTapAddImage(_ sender: UIButton) {
//		present(imagePickerController, animated: true, completion: nil)
		navigationController?.pushViewController(imagePickerController, animated: true)
		
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

extension AddEventViewController: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
	 // get the current text, or use an empty string if that failed
	 let currentText = textView.text ?? ""

	 // attempt to read the range they are trying to change, or exit if we can't
	 guard let stringRange = Range(range, in: currentText) else { return false }

	 // add their new text to the existing text
	 let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

	 // make sure the result is under 16 characters
	 return updatedText.count <= 140
 }
}

extension AddEventViewController: ImagePickerDelegate {
	func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		return
	}
	
	func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
		navigationController?.popViewController(animated: true)
	}
	
	func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
		if images.count > 0 {
			imageView.image = images[0]
		}
		navigationController?.popViewController(animated: true)
	}
		
}



extension Date {
	func toMillis() -> UInt64! {
		return UInt64(self.timeIntervalSince1970 * 1000)
	}
}
