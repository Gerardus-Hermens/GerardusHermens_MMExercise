//
//  PhotoDetailViewController.swift
//  GerardusHermens_MMExercise
//
//  Created by Billionaire on 2018-07-02.
//  Copyright © 2018 GHermens. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    let photoDetailDM = PhotoListDataModel()
    
    var photoURL : String = ""
    var photoTitle : String = ""
    var albumId : String = ""
    var photoId : String = ""
    
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumIdLabel: UILabel!
    @IBOutlet weak var photoURLLabel: UILabel!
    @IBOutlet weak var photoIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Details"
        
        print("\(albumId) - \(photoId) - \(photoTitle) - \(photoURL)")
        
        photoImage.layer.cornerRadius = photoImage.bounds.width / 10
        photoImage.clipsToBounds = true
        
        photoImage.image = photoDetailDM.getImageByURL(imageURLString: photoURL)
        photoURLLabel.text = "\(photoURL)"
        titleLabel.text = "\(photoTitle)"
        albumIdLabel.text = "album: \(albumId)"
        photoIdLabel.text = "photo: \(photoId)"
    }
}
