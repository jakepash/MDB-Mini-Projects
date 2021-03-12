//
//  AuthProvider.swift
//  MDB Social
//
//  Created by Michael Lin on 2/25/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FIRAuthProvider {
    
    static let shared = FIRAuthProvider()
    
    let auth = Auth.auth()
    
    enum SignInErrors: Error {
        case wrongPassword
        case userNotFound
        case invalidEmail
        case internalError
        case errorFetchingUserDoc
        case errorDecodingUserDoc
        case unspecified
		
		case emailInUse
		case weakPassword
    }
	
    
    let db = Firestore.firestore()
    
    var currentUser: User?
    
    private var userListener: ListenerRegistration?
    
    init() {
        guard let user = auth.currentUser else { return }
        
        linkUser(withuid: user.uid, completion: nil)
    }
    
	func signIn(withEmail email: String, password: String,
                completion: ((Result<User, SignInErrors>)->Void)?) {
        
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let nsError = error as NSError
                let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
                
                switch errorCode {
                case .wrongPassword:
                    completion?(.failure(.wrongPassword))
                case .userNotFound:
                    completion?(.failure(.userNotFound))
                case .invalidEmail:
                    completion?(.failure(.invalidEmail))
                default:
                    completion?(.failure(.unspecified))
                }
                return
            }
            
            guard let authResult = authResult else {
                completion?(.failure(.internalError))
                return
            }
            
            self?.linkUser(withuid: authResult.user.uid, completion: completion)
        }
    }
    
    /* TODO: Firebase sign up handler, add user to firestore */
	func signUp(withEmail email: String, password: String, fullname: String, username: String,
				completion: ((Result<User, SignInErrors>)->Void)?) {
		auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
			if let error = error {
				let nsError = error as NSError
				let errorCode = FirebaseAuth.AuthErrorCode(rawValue: nsError.code)
				
				switch errorCode {
				case .emailAlreadyInUse:
					completion?(.failure(.emailInUse))
				case .weakPassword:
					completion?(.failure(.weakPassword))
				default:
					completion?(.failure(.unspecified))
				}
				return
			}
			
			guard let authResult = authResult else {
				completion?(.failure(.internalError))
				return
			}
			
			
			self?.addUser(withuid: authResult.user.uid, email: email, fullname: fullname, username: username, completion: completion)
		}
	}
    
    func isSignedIn() -> Bool {
        return auth.currentUser != nil
    }
    
    func signOut(completion: (()->Void)? = nil) {
        do {
            try auth.signOut()
            unlinkCurrentUser()
            completion?()
        } catch { }
    }
    
    private func linkUser(withuid uid: String,
                          completion: ((Result<User, SignInErrors>)->Void)?) {
        
        userListener = db.collection("users").document(uid).addSnapshotListener { [weak self] docSnapshot, error in
            guard let document = docSnapshot else {
                completion?(.failure(.errorFetchingUserDoc))
                return
            }
            guard let user = try? document.data(as: User.self) else {
                completion?(.failure(.errorDecodingUserDoc))
                return
            }
            
            self?.currentUser = user
            completion?(.success(user))
        }
    }
	
	private func addUser(withuid uid: String, email: String, fullname: String, username: String,
						  completion: ((Result<User, SignInErrors>)->Void)?) {
		currentUser = User(uid: uid, username: username, email: email, fullname: fullname, savedEvents: [])
		
		if let user = currentUser {
			FIRDatabaseRequest().setUser(user, completion: {
				completion?(.success(user))
				
			})
		}
		
	}

	
	
    
    private func unlinkCurrentUser() {
        userListener?.remove()
        currentUser = nil
    }
}
