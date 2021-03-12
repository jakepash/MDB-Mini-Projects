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
}
