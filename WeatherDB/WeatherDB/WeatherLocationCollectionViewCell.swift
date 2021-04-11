//
//  WeatherLocationCollectionViewCell.swift
//  WeatherDB
//
//  Created by Jacob Pashman on 4/5/21.
//

import UIKit

class WeatherLocationCollectionViewCell: UICollectionViewCell {
	static let reuseIdentifier: String = String(describing: WeatherLocationCollectionViewCell.self)

	var weather: Weather!
	
	let locationLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18)
		label.textColor = .label
		label.textAlignment = .left
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let temperatureLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18)
		label.textColor = .label
		label.textAlignment = .right
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.addSubview(locationLabel)
		contentView.addSubview(temperatureLabel)
		contentView.backgroundColor = .systemGray
		
		NSLayoutConstraint.activate([
			locationLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
			
			temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
