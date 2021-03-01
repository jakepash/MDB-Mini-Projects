//
//  DetailsViewController.swift
//  Pokedex
//
//  Created by Jacob Pashman on 2/28/21.
//

import UIKit

class DetailsViewController: UIViewController {
	
	var pokemon: Pokemon!
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .darkGray
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 35, weight: .bold)
		return label
	}()
	
	let imageView: UIImageView = {
		let view = UIImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.contentMode = .scaleAspectFit
		return view
	}()
	
	let stackView: UIStackView = {
		let view = UIStackView()
		view.axis = NSLayoutConstraint.Axis.vertical
		view.distribution = UIStackView.Distribution.equalSpacing
		view.alignment = UIStackView.Alignment.center
		view.spacing = 16.0
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	let attack: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	
	let defense: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	
	let health: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	
	let specialAttack: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	
	let speed: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	
	let total: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	

	
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		nameLabel.text = "\(pokemon.name) - \(pokemon.id)"
		imageView.kf.setImage(with: URL(string: pokemon.imageUrlLarge))
		view.addSubview(nameLabel)
		view.addSubview(imageView)
		view.addSubview(stackView)
		view.backgroundColor = .white
		
		attack.text =  "attack: \(pokemon.attack)"
		stackView.addArrangedSubview(attack)

		defense.text =  "defense: \(pokemon.defense)"
		stackView.addArrangedSubview(defense)
		
		health.text =  "health: \(pokemon.health)"
		stackView.addArrangedSubview(health)
		
		specialAttack.text =  "defense: \(pokemon.specialAttack)"
		stackView.addArrangedSubview(specialAttack)
		
		
		speed.text =  "speed: \(pokemon.speed)"
		stackView.addArrangedSubview(speed)
		
		total.text =  "total: \(pokemon.total)"
		stackView.addArrangedSubview(total)
		
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			imageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
			stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
										
		])
		
		
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
