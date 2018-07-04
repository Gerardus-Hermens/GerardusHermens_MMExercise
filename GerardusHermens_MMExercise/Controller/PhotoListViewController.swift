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
import ProgressHUD

class PhotoListViewController: UIViewController {

    //variable used to store data for segue to PhotoListViewController
    var albumIdFromSegue : Int = 0
    
    //new instance of PhotoListDataModel
    let photoListDM = PhotoListDataModel()
    
    //url for fetching data from web
    let photoListURL = "https://jsonplaceholder.typicode.com/photos"
    
    //IBOutlets
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Photos"
        
        setCollectionViewDimensionProperties()
        fetchPhotoListByAlbumIds()
        
        //cocoapod loading animation start when page is
        //loaded and thumbnailURLs are still loading in
        ProgressHUD.show()
    }
    
    
    //function to set collectionview and collectionviewcell properties
    func setCollectionViewDimensionProperties() {
        
        let cellSize = UIScreen.main.bounds.width / 3 - 7.5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5  )
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        photoListCollectionView.collectionViewLayout = layout
    }
    
    //function that calls webrequest function
    func fetchPhotoListByAlbumIds() {
        
        getAlbumPhotos(url: photoListURL)
    }
    
    //function for fetching data from web using Alamofire (cocoapod)
    func getAlbumPhotos(url: String) {
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON {
            response in
            if response.result.isSuccess {
                let photoListJSON : JSON = JSON(response.result.value!)
                self.createPhotoListArrays(json: photoListJSON, albumId: self.albumIdFromSegue)
            } else {
                print("fetched photos failed :(")
            }
        }
    }
    
    //function to store necessary JSON data in arrays
    func createPhotoListArrays(json : JSON, albumId : Int) {
        
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
        
        //cocoapod loading animation dismissal
        ProgressHUD.dismiss()
        
        photoListCollectionView.reloadData()
    }


    // function for segue preparation for PhotoDetailViewController
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

//extension that contains all collectionview related functions
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
