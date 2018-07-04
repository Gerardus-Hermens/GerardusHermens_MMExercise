//
//  PhotoListViewController.swift
//  GerardusHermens_MMExercise
//
//  Created by Billionaire on 2018-07-02.
//  Copyright © 2018 GHermens. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PhotoListViewController: UIViewController {

    var albumIdFromSegue : Int = 0
    let photoListDM = PhotoListDataModel()
    let photoListURL = "https://jsonplaceholder.typicode.com/photos"
    
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Photos"
        
        print(albumIdFromSegue)
        
        let cellSize = UIScreen.main.bounds.width / 3 - 7.5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5  )
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        photoListCollectionView.collectionViewLayout = layout
        
        fetchPhotoListByAlbumIds()
    }
    
    
    func fetchPhotoListByAlbumIds() {
        
        getAlbumPhotos(url: photoListURL)
    }
    
    func getAlbumPhotos(url: String) {
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            if response.result.isSuccess {
                print("fetched photos successful :)")
                let photoListJSON : JSON = JSON(response.result.value!)
                self.createPhotoListArrays(json: photoListJSON, albumId: self.albumIdFromSegue)
            } else {
                print("fetched photos failed :(")
            }
        }
    }
    
    func createPhotoListArrays(json : JSON, albumId : Int) {
        
        print(albumId)
        
        for album in 0..<json[].count {
            
            if json[album]["albumId"].intValue == albumId {
                
                photoListDM.albumIdArray.append(json[album]["albumId"].intValue)
                photoListDM.photoIdArray.append(json[album]["id"].intValue)
                photoListDM.titleArray.append(json[album]["title"].stringValue)
                photoListDM.thumbnailURLArray.append(json[album]["thumbnailUrl"].stringValue)
                photoListDM.photoURLArray.append(json[album]["url"].stringValue)
                
                let currentThumbNailImage = photoListDM.getImageByURL(imageURLString: json[album]["thumbnailUrl"].stringValue)
                photoListDM.thumbnailImageArray.append(currentThumbNailImage)
            }
        }
        
        photoListCollectionView.reloadData()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueWithPhotoDetailData" {
            
            let photoDetailVC = segue.destination as! PhotoDetailViewController
            
            photoDetailVC.albumId = String(photoListDM.albumId)
            photoDetailVC.photoId = String(photoListDM.photoId)
            photoDetailVC.photoTitle = photoListDM.title
            photoDetailVC.photoURL = photoListDM.photoURL
        }
    }

}


extension PhotoListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoListDM.albumIdArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoListCollectionViewCell
        
        cell.thumbnailImage.image = photoListDM.thumbnailImageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        photoListDM.albumId = photoListDM.albumIdArray[indexPath.row]
        photoListDM.photoId = photoListDM.photoIdArray[indexPath.row]
        photoListDM.title = photoListDM.titleArray[indexPath.row]
        photoListDM.photoURL = photoListDM.photoURLArray[indexPath.row]
        
        performSegue(withIdentifier: "segueWithPhotoDetailData", sender: self)
        
        return true
    }
    
}
