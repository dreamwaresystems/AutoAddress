//
//  MainVC.swift
//  AutoAddress
//
//  Created by Mike Jones on 2/25/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import UIKit
import Foundation

enum LocationType: Int {
    case From = 1
    case To = 2
}

class MainVC: UIViewController {
    
    @IBOutlet var searchBarTop: UISearchBar!
    //@IBOutlet var searchBarBottom: UISearchBar!
    
    var selectingLocation = LocationType.From
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarTop.tag = LocationType.From.rawValue
        searchBarTop.delegate = self
        
        //searchBarBottom.tag = LocationType.To.rawValue
        //searchBarBottom.delegate = self
    }

}

extension MainVC: UISearchBarDelegate {

    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        selectingLocation = LocationType(rawValue: searchBar.tag) ?? LocationType.From

        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        guard let searchVC = storyboard.instantiateViewController(withIdentifier:"SearchVC") as? SearchVC else {
            return false
        }
        searchVC.delegate = self
        navigationController?.pushViewController(searchVC, animated: true)
        return false // don't become first responder
    }
}

extension MainVC: SearchPlacesDelegate {
    
    public func didSelectPlace(_ place:Place) {
        searchBarTop.text = place.desc
    }
}
