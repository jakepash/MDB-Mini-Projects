//
//  Singleton.swift
//  WeatherDB
//
//  Created by Jacob Pashman on 4/11/21.
//

import Foundation
import CoreLocation

protocol SingletonDelegate: class {
	func variableDidChange(location value: CLLocation?)
}

class Singleton {

	var currentLocation: CLLocation? = CLLocation() {
	   didSet {
		  delegate?.variableDidChange(location: currentLocation)
	   }
	}

	private init() {}
	weak var delegate: SingletonDelegate?

	static let shared = Singleton()
}
