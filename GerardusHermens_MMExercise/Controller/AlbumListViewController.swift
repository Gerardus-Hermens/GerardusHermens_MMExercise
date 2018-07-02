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
    

    @IBOutlet weak var albumTableView: UITableView!
    let albumURL = "https://jsonplaceholder.typicode.com/albums"
    var albumIdArray = [Int]()
    var albumTitleArray = [String]()
    var albumForPhotolistVC : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAlbumsByIds()
    }
    
    
    func fetchAlbumsByIds() {
        
        getAlbumData(url: albumURL)
    }
    
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
    
    func createAlbumArrays(json: JSON) {
        
        for idAndTitle in 0..<json[].count {
            
            albumIdArray.append(json[idAndTitle]["id"].intValue)
            albumTitleArray.append(json[idAndTitle]["title"].stringValue)
            
            print("\(albumIdArray.count) - \(albumTitleArray.count)")
        }
        
        albumTableView.reloadData()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }

}

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
}

