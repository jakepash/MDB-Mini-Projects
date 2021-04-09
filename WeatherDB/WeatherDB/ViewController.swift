//
//  ViewController.swift
//  WeatherDB
//
//  Created by Michael Lin on 3/20/21.
//

import UIKit
import CoreLocation
import GooglePlaces

class ViewController: UIViewController {
	
	var locations: [CLLocation] = []
	
	private let weatherLocationsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 30
		layout.minimumInteritemSpacing = 30
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(WeatherLocationCollectionViewCell.self, forCellWithReuseIdentifier: WeatherLocationCollectionViewCell.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))

		fetchLocations()

		view.addSubview(weatherLocationsCollectionView)
		weatherLocationsCollectionView.dataSource = self
		weatherLocationsCollectionView.delegate = self
		weatherLocationsCollectionView.backgroundColor = .white
		
		NSLayoutConstraint.activate([
			weatherLocationsCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
			weatherLocationsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			weatherLocationsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			weatherLocationsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
	}
	
	
	func fetchLocations() {
		let defaultLocation = CLLocation(latitude: 37.8715, longitude: -122.2730)
		let savedLocations = UserDefaults.standard.array(forKey: "locations") as? [CLLocation] ?? [defaultLocation]
		locations.append(contentsOf: savedLocations)
//		let currentLocation = LocationManager.shared.location
//		locations.append(currentLocation!)
		

	}
	
	@objc func addTapped(_ sender: UIButton) {
		let autocompleteController = GMSAutocompleteViewController()
		autocompleteController.delegate = self

		// Specify the place data types to return.
		let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
													UInt(GMSPlaceField.placeID.rawValue))
		autocompleteController.placeFields = fields

		// Specify a filter.
		let filter = GMSAutocompleteFilter()
		filter.type = .city
		autocompleteController.autocompleteFilter = filter
		
		present(autocompleteController, animated: true, completion: nil)
	}
    
}


extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return locations.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let location = locations[indexPath.item]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherLocationCollectionViewCell.reuseIdentifier, for: indexPath) as! WeatherLocationCollectionViewCell
		
		WeatherRequest.shared.weather(at: location, completion: { result in
				   switch result {
				   case .success(let weather):
					   print(weather)
					DispatchQueue.main.async {
						cell.locationLabel.text = weather.name
						cell.temperatureLabel.text = "\(weather.main.temperature)°"
						cell.weather = weather
					}
				   case .failure(let error):
					   print(error)
				   }
			   })
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("\(indexPath.row) selected")
		let vc = WeatherDetailViewController()
		let collectionView = collectionView.cellForItem(at: indexPath) as! WeatherLocationCollectionViewCell
		vc.weather = collectionView.weather
		navigationController?.pushViewController(vc, animated: true)
	}
	
	
	func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(address) { (placemarks, error) in
			guard let placemarks = placemarks,
			let location = placemarks.first?.location?.coordinate else {
				completion(nil)
				return
			}
			completion(location)
		}
	}
}

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 300, height: 200)
	}

}

extension ViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
	print("Place name: \(place.name)")
	print("Place ID: \(place.placeID)")
//	getLocation(from: place.name ?? "") { location in
//		locations.append(location)
//	})
	let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
	locations.append(location)
	weatherLocationsCollectionView.reloadData()
	print("Place attributions: \(place.attributions)")
	dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
	// TODO: handle the error.
	print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
	dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
	UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
	UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
