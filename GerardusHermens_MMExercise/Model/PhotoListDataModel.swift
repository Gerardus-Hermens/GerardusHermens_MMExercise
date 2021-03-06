//
//  PhotoListDataModel.swift
//  GerardusHermens_MMExercise
//
//  Created by Billionaire on 2018-07-02.
//  Copyright © 2018 GHermens. All rights reserved.
//

import Foundation
import UIKit

class PhotoListDataModel {
    
    //variables
    var albumId : Int = 0
    var photoId : Int = 0
    var title : String = ""
    var thumbnailURL : URL?
    var photoURL : String = ""
    var photoImage : UIImage?
    
    //arrays
    var albumIdArray = [Int]()
    var photoIdArray = [Int]()
    var titleArray = [String]()
    var thumbnailURLArray = [String]()
    var photoURLArray = [String]()
    var thumbnailImageArray = [UIImage]()
    
    
    //function that retrieves the specific image from url
    //input url
    //output UIImage
    func getImageByURL(imageURLString : String) -> UIImage {
        
        let url = URL(string: imageURLString)
        if let data = try? Data(contentsOf: url!) {
            photoImage = UIImage(data: data)
        } else {
            print("No photo found :(")
        }
        
        return photoImage!
    }
}
