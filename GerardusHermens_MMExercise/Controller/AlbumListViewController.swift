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
    
    //url for fetching data from web
    let albumURL = "https://jsonplaceholder.typicode.com/albums"
    
    //new instance of AlbumListDataModel
    let albumListDM = AlbumListDataModel()
    
    //variable used for segue to PhotoListViewController
    var albumIdForPhotolistVCSegue : Int = 0
    
    //new instance of UISearchBar
    let searchBar = UISearchBar()
    
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
            
            albumListDM.albumIdArray.append(json[idAndTitle]["id"].intValue)
            albumListDM.albumTitleArray.append(json[idAndTitle]["title"].stringValue)
        }
        
        albumTableView.reloadData()
    }


    // function for segue preparation for PhotoListViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueWithAlbumId" {
            
            let photoListVC = segue.destination as! PhotoListViewController
            photoListVC.albumIdFromSegue = albumIdForPhotolistVCSegue
        }
    }

}


//extension that contains all tableview related functions
extension AlbumListViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if albumListDM.willShowSearchResults {
            return albumListDM.filteredAlbumTitleArray.count
        } else {
            return albumListDM.albumIdArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumcell", for: indexPath) as! AlbumListTableViewCell
        
        if albumListDM.willShowSearchResults {
            cell.albumIdLabel.text = String(albumListDM.albumIdArray[indexPath.row])
            cell.albumTitleLabel.text = albumListDM.filteredAlbumTitleArray[indexPath.row]
            return cell
        } else {
            cell.albumIdLabel.text = String(albumListDM.albumIdArray[indexPath.row])
            cell.albumTitleLabel.text = albumListDM.albumTitleArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if albumListDM.willShowSearchResults {
            for id in 0..<albumListDM.albumTitleArray.count {
                if String(albumListDM.albumTitleArray[id]) == String(albumListDM.filteredAlbumTitleArray[indexPath.row]) {
                    
                    albumIdForPhotolistVCSegue = albumListDM.albumIdArray[id]
                }
            }
        } else {
            albumIdForPhotolistVCSegue = albumListDM.albumIdArray[indexPath.row]
        }
        
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
        
        albumListDM.filteredAlbumTitleArray = albumListDM.albumTitleArray.filter({ (names: String) -> Bool in
            
            return names.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        if searchText != "" {
            
            albumListDM.willShowSearchResults = true
            self.albumTableView.reloadData()
        } else {
            
            albumListDM.willShowSearchResults = false
            self.albumTableView.reloadData()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        albumListDM.willShowSearchResults = true
        albumSearchBar.endEditing(true)
        self.albumTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        albumSearchBar.endEditing(true)
    }
}









