//
//  SearchPlacesViewController.swift
//  SignosPlaces
//
//  Created by Stephen Brundage on 7/10/21.
//

import UIKit

protocol SearchPlacesDelegate: AnyObject {
	func updateSavedPlaceModels(updatedModels: [PlaceViewModel])
}

class SearchPlacesViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	private var searchPlacesVM = SearchPlacesViewModel()
	
	weak var delegate: SearchPlacesDelegate?
	private var savedPlaces: [Place] = []
	var savedPlaceVMs: [PlaceViewModel] = [] {
		didSet {
			savedPlaces = savedPlaceVMs.map { $0.getPlace() }
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		searchBar.placeholder = "Search for a place to add"

		searchBar.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.register(PlaceCell.nib, forCellReuseIdentifier: PlaceCell.identifier)
		
		searchPlacesVM.delegate = self
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		delegate?.updateSavedPlaceModels(updatedModels: savedPlaceVMs)
	}

}

extension SearchPlacesViewController: GoogleSearchPlacesDelegate {
	func searchResultsFound() {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	func errorWhileSearching(error: Error) {
		print("Error while searching: \(error)")
	}
}

extension SearchPlacesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let placeVM = searchPlacesVM.placeViewModels[indexPath.section]
		
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			cell.textLabel?.text = placeVM.getPlace().address
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell else {
				// Instead of returing an empty cell, return a custom cell that states "there are no search results. Please try again"
				return UITableViewCell()
			}
			cell.delegate = self
			cell.initializePlaceCell(with: placeVM)
			return cell
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return searchPlacesVM.placeViewModels.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let place = searchPlacesVM.placeViewModels[section].getPlace()
		return place.isOpened ? 2 : 1
	}
}

extension SearchPlacesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		searchPlacesVM.placeViewModels[indexPath.section].toggleIsExpanded()
		UIView.setAnimationsEnabled(false)
		let sections = IndexSet.init(integer: indexPath.section)
		tableView.reloadSections(sections, with: .bottom)
	}
}

extension SearchPlacesViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text else { return }
		searchPlacesVM.searchForPlaces(with: searchText)
	}
}

extension SearchPlacesViewController: PlaceCellDelegate {
	func placeAdded(newPlaceVM: PlaceViewModel) {
		if !savedPlaces.contains(where: { $0.address == newPlaceVM.getPlace().address }) {
			savedPlaceVMs.append(newPlaceVM)
		}
	}
	
	func placeRemoved(place: Place) {
		print("Remove place: \(place)")
		// filter out the removed place from savedPlaces array
	}
}

