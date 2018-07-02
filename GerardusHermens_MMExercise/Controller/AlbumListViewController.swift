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
    
    // 2 arrays to store web data fetched via JSON
    var albumIdArray = [Int]()
    var albumTitleArray = [String]()

    //IBOutlets
    @IBOutlet weak var albumTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            photoListVC.albumIdFromSegue = albumIdForPhotolistVCSegue + 1
            
            print(photoListVC.albumIdFromSegue)
        }
    }

}


//extension that contains all tableview related functions
extension AlbumListViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumcell", for: indexPath) as! AlbumListTableViewCell
        
        cell.albumIdLabel.text = String(albumIdArray[indexPath.row])
        cell.albumTitleLabel.text = albumTitleArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        albumIdForPhotolistVCSegue = indexPath.row
        performSegue(withIdentifier: "segueWithAlbumId", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

