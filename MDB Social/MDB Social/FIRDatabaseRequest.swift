//
//  FIRDatabaseRequest.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FIRDatabaseRequest {
    
    static let shared = FIRDatabaseRequest()
    
    let db = Firestore.firestore()
    
    func setUser(_ user: User, completion: (()->Void)?) {
        guard let uid = user.uid else { return }
        do {
            try db.collection("users").document(uid).setData(from: user)
            completion?()
        }
        catch { }
    }
    
    func setEvent(_ event: Event, completion: (()->Void)?) {
        guard let id = event.id else { return }
        
        do {
            try db.collection("events").document(id).setData(from: event)
            completion?()
        } catch { }
    }
    
    /* TODO: Events getter */
	
	func getEvents(_ completion: (([QueryDocumentSnapshot])->Void)?) {
		db.collection("events")
			.addSnapshotListener { querySnapshot, error in
				guard let documents = querySnapshot?.documents else {
					print("Error fetching documents: \(error!)")
					return
				}
				print("Current data: \(documents)")
				completion?(documents)
			}


		
		
	}
	
	func getImage(_ path: String, completion: ((UIImage)->Void)?) {
		let storage = Storage.storage()
		let gsReference = storage.reference(forURL: path)
		
		gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
		  if let error = error {
			// Uh-oh, an error occurred!
		  } else {
			// Data for "images/island.jpg" is returned
			if let image = UIImage(data: data!) {
				completion?(image)
			}
			
		  }
		}
		
		
		

	}
	
	func getUsername(_ uid: String, completion: ((String)->Void)?) {
		let docRef = db.collection("users").document(uid)

		docRef.getDocument { (document, error) in
			if let document = document, document.exists {
				let fullname = document.get("fullname") as? String
				if let fullname = fullname {
					completion?(fullname)
				}
//				let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//				print("Document data: \(dataDescription)")
//				completion?(dataDescription)
			} else {
				print("Document does not exist")
			}
		}
	}
	
	func uploadImage(_ image: UIImage, id: String, completion: (()->Void)?) {
		let storage = Storage.storage()
		let gsReference = storage.reference(forURL: id)
//		let pathReference = storage.reference(withPath: "\(id).jpg")
		let newMetadata = StorageMetadata()
		newMetadata.contentType = "image/jpeg";
		if let uploadData = image.resized(toWidth: 72.0)!.pngData() {
			gsReference.putData(uploadData, metadata: newMetadata) { (metadata, error) in
				if error != nil {
					print(error?.localizedDescription)
				} else {
					completion?()
					print("photo uploaded")
				}
			}
		}
		
		
		
	}
	
	func deleteEvent(eventID: String, completion: (() -> Void)?) {
		db.collection("events").document(eventID).delete() { err in
			if let err = err {
				print("Error removing document: \(err)")
			} else {
				print("Document successfully removed!")
				completion?()
			}
		}

	}


	
		
		
}

extension UIImage {
	func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
		let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
		let format = imageRendererFormat
		format.opaque = isOpaque
		return UIGraphicsImageRenderer(size: canvas, format: format).image {
			_ in draw(in: CGRect(origin: .zero, size: canvas))
		}
	}
	func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
		let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
		let format = imageRendererFormat
		format.opaque = isOpaque
		return UIGraphicsImageRenderer(size: canvas, format: format).image {
			_ in draw(in: CGRect(origin: .zero, size: canvas))
		}
	}
}
