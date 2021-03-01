//
//  ViewController.swift
//  Pokedex
//
//  Created by Michael Lin on 2/18/21.
//

import UIKit
import Kingfisher

class PokedexVC: UIViewController {
    
    let pokemons = PokemonGenerator.shared.getPokemonArray()
	var filteredPokemons: [Pokemon] = []
	var filteredTypes: Set<PokeType> = []
	var textSearched = ""
	
	var viewLayout = "large"
	
	let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumLineSpacing = 30
		layout.minimumInteritemSpacing = 30
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		return collectionView
	}()
	
	let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Search Pokemon"
		searchBar.enablesReturnKeyAutomatically = false
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		return searchBar
	}()
	
	let filterButton: UIButton = {
		let button = UIButton()
		button.setTitle("Advanced Filter", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()
	
	let segmentedControl: UISegmentedControl = {
		let view = UISegmentedControl(items: ["Grid", "Row"])
		view.selectedSegmentIndex = 0
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.addSubview(collectionView)
		collectionView.backgroundColor = .clear
		
		collectionView.allowsSelection = true
		collectionView.allowsMultipleSelection = false
		
		collectionView.dataSource = self
		collectionView.delegate = self
		searchBar.showsBookmarkButton = true
		searchBar.setImage(UIImage(named: "sort"), for: .bookmark, state: .normal)
		view.addSubview(searchBar)
		view.addSubview(segmentedControl)
		segmentedControl.addTarget(self, action: #selector(didTapControl(_:)), for: .valueChanged)
		NSLayoutConstraint.activate([
			
			searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
			segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

			
			collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			
		])
		searchBar.delegate = self
		
		filteredPokemons = pokemons
		for type in PokeType.allCases {
			filteredTypes.insert(type)
		}

	}
	
	@objc func didTapControl(_ sender: UISegmentedControl) {
		collectionView.collectionViewLayout.invalidateLayout()
	}
	
	func filter() {
		filteredPokemons = pokemons.filter { pokemon in
			for type in pokemon.types {
				if filteredTypes.contains(type) {
					if textSearched == "" || pokemon.name.contains(textSearched) {
						return true
					}
				}
			}
			return false
		}
		collectionView.reloadData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		print(filteredTypes)
		filter()
	}
		
}

extension PokedexVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filteredPokemons.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let pokemon = filteredPokemons[indexPath.item]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.reuseIdentifier, for: indexPath) as! PokemonCollectionViewCell
		cell.imageView.kf.setImage(with: URL(string: pokemon.imageUrlLarge))
		cell.titleView.text = "\(pokemon.name) - \(pokemon.id)"
		return cell
	}
}

extension PokedexVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if segmentedControl.selectedSegmentIndex == 0 {
			return CGSize(width: 100, height: 100)
		}
		return CGSize(width: 300, height: 200)
	}

	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let pokemon = filteredPokemons[indexPath.item]
		print("Selected \(pokemon.name)")
		let vc = DetailsViewController()
		vc.pokemon = pokemon
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension PokedexVC: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
		self.textSearched = textSearched
		filter()
		
	}
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.endEditing(true)
	}
	
	func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		let vc = FilterViewController()
		vc.filteredTypes = filteredTypes
		navigationController?.pushViewController(vc, animated: true)
	}
	
}

