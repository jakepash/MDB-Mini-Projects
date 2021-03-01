//
//  FilterViewController.swift
//  Pokedex
//
//  Created by Jacob Pashman on 2/28/21.
//

import UIKit

class FilterViewController: UIViewController {
	

	var filteredTypes: Set<PokeType>!
	
	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.allowsMultipleSelection = true
		return tableView
	}()
	
	let backButton: UIButton = {
		let button = UIButton()
		button.setTitle("Back", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		return button
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		view.addSubview(tableView)
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self
		self.tableView.allowsMultipleSelectionDuringEditing = true
		self.tableView.setEditing(true, animated: false)
		
		
		backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
		
		let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapBack(_:)))
		self.navigationItem.leftBarButtonItem = newBackButton
		
		
		NSLayoutConstraint.activate([

			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
		
		

    }
	
	@objc func didTapBack(_ sender: UIBarButtonItem) {
		let a = self.navigationController!.viewControllers[0] as! PokedexVC
		a.filteredTypes = filteredTypes
		navigationController?.popViewController(animated: true)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		for i in 0..<PokeType.allCases.count {
			if filteredTypes.contains(PokeType.allCases[i]) {
				tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
			}
		}
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

extension FilterViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return PokeType.allCases.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let type = PokeType.allCases[indexPath.row].rawValue
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = type
		cell.selectedBackgroundView?.backgroundColor = .white
		
		
		return cell
	}
	
	
	
}

extension FilterViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .none
			filteredTypes.remove(PokeType(rawValue: (cell.textLabel?.text)!)!)
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) {
			cell.accessoryType = .checkmark
			filteredTypes.insert(PokeType(rawValue: (cell.textLabel?.text)!)!)
		}
		
	}
	
	
	
}

