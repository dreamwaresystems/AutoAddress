//
//  SearchVC.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/7/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit

// delegate to communicate search selections back to main VC
protocol SearchPlacesDelegate: AnyObject {
    func didSelectPlace(_ place: Place)
}


class SearchVC: UITableViewController {

    let placesAPI = PlacesWS()  // web service manager
    var placeList = [Place]()   // array of suggested autocompletions
    var searchCtrl = UISearchController(searchResultsController: nil)
    
    weak var delegate: SearchPlacesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController? = true
        
        searchCtrl.searchResultsUpdater = self
        searchCtrl.obscuresBackgroundDuringPresentation = false
        searchCtrl.searchBar.placeholder = "Enter a location"
        
        navigationItem.hidesBackButton = true
        navigationItem.searchController = searchCtrl
        definesPresentationContext = true
        
        //tableView.tableHeaderView = searchCtrl.view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchCtrl.isActive = true
        searchCtrl.searchBar.delegate = self
    }
}

extension SearchVC {
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:"searchCell", for: indexPath) as? SearchCell else {
            print("Error: unable to dequeue a SearchCell")
            return UITableViewCell()
        }
        
        let title = placeList[indexPath.row].structured_main
        let detail = placeList[indexPath.row].structured_second
        cell.configureCellForDisplay(titleText:title, detailText:detail)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeObj = placeList[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didSelectPlace(placeObj)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
    

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 2 else {
            return
        }
        
        placesAPI.asyncRecordSearch(searchText:text, completion:{ (list, error) in
            self.placeList = list ?? Array();
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        print(text)
    }
    
}

