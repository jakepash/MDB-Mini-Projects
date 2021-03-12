//
//  FeedCollectionViewCell.swift
//  MDB Social
//
//  Created by Jacob Pashman on 3/6/21.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
	static let reuseIdentifier: String = String(describing: FeedCollectionViewCell.self)
	
	let imageView: UIImageView = {
		let iv = UIImageView()
		iv.tintColor = .white
		iv.contentMode = .scaleAspectFit
		iv.clipsToBounds = true
		
		iv.translatesAutoresizingMaskIntoConstraints = false
		return iv
	}()
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18)
		label.textColor = .black
		label.textAlignment = .right
//		label.numberOfLines = 1
		
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let authorLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textColor = .black
		label.textAlignment = .right
//		label.numberOfLines = 1
		
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	let rsvpLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 14)
		label.textColor = .black
		label.textAlignment = .right
//		label.numberOfLines = 1
		
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	
	let rsvpButton: UIButton = {
		let button = UIButton()
		button.setTitle("RSVP", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	let stackView: UIStackView = {
		let view = UIStackView()
		view.axis = NSLayoutConstraint.Axis.vertical
		view.distribution = UIStackView.Distribution.equalSpacing
		view.alignment = UIStackView.Alignment.leading
		view.spacing = 5
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let loadingidicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView(style: .large)
		indicator.translatesAutoresizingMaskIntoConstraints = false
		
		return indicator
	}()

	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		contentView.backgroundColor = .gray
		contentView.addSubview(imageView)
		contentView.addSubview(stackView)
		contentView.addSubview(loadingidicator)
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(authorLabel)
		stackView.addArrangedSubview(rsvpLabel)
		
		
		NSLayoutConstraint.activate([
			loadingidicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			loadingidicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			imageView.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			stackView.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
			stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
			stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//			titleLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
//			authorLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
//			authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//			authorLabel.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
			
		])
		
		isLoading(isloading: true)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func isLoading(isloading: Bool) {
		if isloading {
			loadingidicator.isHidden = false
			loadingidicator.startAnimating()
			stackView.isHidden = true
			imageView.isHidden = true
		} else {
			loadingidicator.stopAnimating()
			loadingidicator.isHidden = true
			stackView.isHidden = false
			imageView.isHidden = false
		}
	}
}
