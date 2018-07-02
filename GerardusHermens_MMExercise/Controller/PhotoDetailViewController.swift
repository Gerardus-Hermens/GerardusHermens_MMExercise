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
    
    var photoDetailImage : UIImage?
    var photoURL : String = ""
    var photoTitle : String = ""
    var albumId : String = ""
    var photoId : String = ""
    
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumIdLabel: UILabel!
    @IBOutlet weak var photoIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(albumId) - \(photoId) - \(photoTitle) - \(photoURL)")
    }
}
