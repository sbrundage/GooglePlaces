//
//  SavedPlacesViewController.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/11/21.
//

import UIKit

class SavedPlacesViewController: UIViewController {

	@IBOutlet weak var segmentedControl: UISegmentedControl!
	@IBOutlet weak var tableView: UITableView!
	
	private var savedPlaces: [Place] = [] {
		didSet {
			filteredPlaces = savedPlaces
		}
	}
	private var filteredPlaces: [Place] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()

		navigationController?.navigationBar.topItem?.title = "Saved Places"
		
		tableView.delegate = self
		tableView.dataSource = self
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let searchPlacesVC = segue.destination as? SearchPlacesViewController else { return }
		searchPlacesVC.savedPlaces = savedPlaces
		searchPlacesVC.delegate = self
	}
	
	@IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
			case 0:
				filteredPlaces = savedPlaces
			case 1:
				filteredPlaces = savedPlaces.filter { $0.determinedType == PlaceType.gym }
			case 2:
				filteredPlaces = savedPlaces.filter { $0.determinedType == PlaceType.supermarket }
			case 3:
				filteredPlaces = savedPlaces.filter { $0.determinedType == PlaceType.restaurant || $0.determinedType == PlaceType.food }
			default:
				break
		}
		reloadTableView()
	}
	
	private func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

extension SavedPlacesViewController: SearchPlacesDelegate {
	func updateSavedPlaces(updatedPlaces: [Place]) {
		savedPlaces = updatedPlaces
		reloadTableView()
	}
}

extension SavedPlacesViewController: UITableViewDelegate {}

extension SavedPlacesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filteredPlaces.count }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = filteredPlaces[indexPath.row].name
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int { 1 }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		.delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		
		savedPlaces.remove(at: indexPath.row)
		
		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .fade)
		tableView.endUpdates()
	}
}
