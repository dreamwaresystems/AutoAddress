//
//  PlacesWS.swift
//  AutoAddress
//
//  Created by Mike Jones on 3/7/19.
//  Copyright © 2019 Mike Jones. All rights reserved.
//

import Foundation
import UIKit

// webservice errors
enum WebServiceError : Error {
    case Connection
    case Parsing
    case Unknown
    var description: String {
        switch self {
        case .Connection:
            return "Unable to connect"
        case .Parsing:
            return "Failed to parse"
        case .Unknown:
            return "Unknown error"
        }
    }
}

// generic web service
protocol RemoteWebService {
    associatedtype X
    func asyncRecordSearch(searchText:String, completion:@escaping(_ response:[X]?, _ error:WebServiceError?) -> Void)
    var recordsPerPage:Int { get }
}

//
// Custom Places WebService
//
class PlacesWS: RemoteWebService {
    
    let session:URLSession = URLSession.shared
    internal var baseURL:String { return "http://www.dreamwaresys.com/api/address/" }
    internal var recordsPerPage:Int { return 25 } // for use in future paginated version

    // fetch data
    func asyncRecordSearch(searchText:String, completion:@escaping(_ response:[Place]?, _ error:WebServiceError?) -> Void) {
        
        let urlstring = baseURL + "get_autocomp.php?code=J23RVFJR&str=" + searchText
        guard let url = URL(string: urlstring) else {
            completion(nil, WebServiceError.Unknown)
            return
        }
        let task = self.session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, WebServiceError.Unknown)
                    print("WebServiceError: " + error.localizedDescription)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, let data = data, response.statusCode == 200, response.mimeType == "application/json" else {
                DispatchQueue.main.async {
                    completion(nil, WebServiceError.Unknown)
                }
                return
            }

            do {
                let responseObj = try JSONDecoder().decode(PlaceResponse.self, from:data)
                let list = responseObj.list
                DispatchQueue.main.async {
                    completion(list, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, WebServiceError.Parsing)
                }
            }
        })
        task.resume()
    }
    
}
