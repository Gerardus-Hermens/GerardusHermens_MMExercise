//
//  AlbumListViewController.swift
//  GerardusHermens_MMExercise
//
//  Created by Billionaire on 2018-07-02.
//  Copyright © 2018 GHermens. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AlbumListViewController: UIViewController {
    
    //variables and arrays
    
    //url fetching data from web
    let albumURL = "https://jsonplaceholder.typicode.com/albums"
    
    //variable used for segue to PhotoListViewController
    var albumIdForPhotolistVCSegue : Int = 0
    
    //new instance of UISearchBar
    let searchBar = UISearchBar()
    
    // 2 arrays to store web data fetched via JSON
    var albumIdArray = [Int]()
    var albumTitleArray = [String]()
    
    // title array and variable for search function filteringt
    var filteredAlbumIdArray = [Int]()
    var filteredAlbumTitleArray = [String]()
    var willShowSearchResults : Bool = false

    //IBOutlets
    @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var albumSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Albums"
        setSearchBar()
        fetchAlbumsByIds()
    }
    
    
    //function that calls webrequest function
    func fetchAlbumsByIds() {
        
        getAlbumData(url: albumURL)
    }
    
    //function for fetching data from web using Alamofire (cocoapod)
    func getAlbumData(url: String) {
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            
            if response.result.isSuccess {
                print("data fetch successful :)")
                let albumJSON : JSON = JSON(response.result.value!)
                self.createAlbumArrays(json: albumJSON)
            } else {
                print("data fetch failed :(")
            }
        }
    }
    
    //function to store necessary JSON data in arrays
    func createAlbumArrays(json: JSON) {
        
        for idAndTitle in 0..<json[].count {
            
            albumIdArray.append(json[idAndTitle]["id"].intValue)
            albumTitleArray.append(json[idAndTitle]["title"].stringValue)
            
            print("\(albumIdArray.count) - \(albumTitleArray.count)")
        }
        
        albumTableView.reloadData()
    }

    
    // MARK: - Navigation

    // function for segue preparation for PhotoListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueWithAlbumId" {
            
            let photoListVC = segue.destination as! PhotoListViewController
            photoListVC.albumIdFromSegue = albumIdForPhotolistVCSegue
            
            print(photoListVC.albumIdFromSegue)
        }
    }

}


//extension that contains all tableview related functions
extension AlbumListViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if willShowSearchResults {
            return filteredAlbumTitleArray.count
        } else {
            return albumIdArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumcell", for: indexPath) as! AlbumListTableViewCell
        
        if willShowSearchResults {
            cell.albumIdLabel.text = String(albumIdArray[indexPath.row])
//            cell.albumIdLabel.text = String(filteredAlbumIdArray[indexPath.row])
            cell.albumTitleLabel.text = filteredAlbumTitleArray[indexPath.row]
            return cell
        } else {
            cell.albumIdLabel.text = String(albumIdArray[indexPath.row])
            cell.albumTitleLabel.text = albumTitleArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if willShowSearchResults {
            for id in 0..<albumTitleArray.count {
                if String(albumTitleArray[id]) == String(filteredAlbumTitleArray[indexPath.row]) {
                    
                    albumIdForPhotolistVCSegue = albumIdArray[id]
                }
            }
        } else {
            albumIdForPhotolistVCSegue = albumIdArray[indexPath.row]
        }
        print(albumTitleArray[indexPath.row])
        performSegue(withIdentifier: "segueWithAlbumId", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//extension that contains all UISearchBar related functions
extension AlbumListViewController : UISearchBarDelegate {
    
    // function that sets seaarchbar perimeters searchbar
    func setSearchBar() {
        
        albumSearchBar.showsCancelButton = false
        albumSearchBar.placeholder = "Enter search here..."
        albumSearchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredAlbumTitleArray = albumTitleArray.filter({ (names: String) -> Bool in
            
            return names.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        if searchText != "" {
            
            willShowSearchResults = true
            self.albumTableView.reloadData()
        } else {
            
            willShowSearchResults = false
            self.albumTableView.reloadData()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        willShowSearchResults = true
        albumSearchBar.endEditing(true)
        self.albumTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        albumSearchBar.endEditing(true)
    }
}









