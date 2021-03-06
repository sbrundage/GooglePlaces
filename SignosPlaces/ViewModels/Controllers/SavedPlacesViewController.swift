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
	
	private var savedPlaceVMs: [PlaceViewModel] = [] {
		didSet {
			savedPlaces = savedPlaceVMs.map { $0.getPlace() }
		}
	}
	
	private var savedPlaces: [Place] = [] {
		didSet {
			filteredPlaces = savedPlaces
		}
	}
	private var filteredPlaces: [Place] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		loadFromUserDefaults()

		navigationController?.navigationBar.topItem?.title = "Saved Places"
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(SavedPlaceCell.nib, forCellReuseIdentifier: SavedPlaceCell.identifier)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		updateUserDefaults()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let searchPlacesVC = segue.destination as? SearchPlacesViewController else { return }
		searchPlacesVC.savedPlaceVMs = savedPlaceVMs
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
	
	private func loadFromUserDefaults() {
		if let persistedData = UserDefaults.standard.value(forKey: "savedPlacesArray") as? Data {
			guard let persistedPlaces = try? PropertyListDecoder().decode([Place].self, from: persistedData) else { return }
			savedPlaces = persistedPlaces
			savedPlaceVMs = savedPlaces.map { PlaceViewModel(place: $0) }
		}
	}
	
	private func updateUserDefaults() {
		UserDefaults.standard.set(try? PropertyListEncoder().encode(savedPlaces), forKey: "savedPlacesArray")
	}
	
	private func reloadTableView() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
}

extension SavedPlacesViewController: SearchPlacesDelegate {
	func updateSavedPlaceModels(updatedModels: [PlaceViewModel]) {
		savedPlaceVMs = updatedModels
		updateUserDefaults()
		reloadTableView()
	}
}

extension SavedPlacesViewController: UITableViewDelegate {}

extension SavedPlacesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { filteredPlaces.count }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedPlaceCell.identifier, for: indexPath) as? SavedPlaceCell else { return UITableViewCell() }
		cell.place = savedPlaces[indexPath.row]
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
		
		savedPlaceVMs.remove(at: indexPath.row)
		
		tableView.beginUpdates()
		tableView.deleteRows(at: [indexPath], with: .fade)
		tableView.endUpdates()
	}
}
