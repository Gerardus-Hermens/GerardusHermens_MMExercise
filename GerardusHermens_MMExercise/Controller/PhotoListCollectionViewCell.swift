//
//  PhotoListCollectionViewCell.swift
//  GerardusHermens_MMExercise
//
//  Created by Billionaire on 2018-07-02.
//  Copyright © 2018 GHermens. All rights reserved.
//

import UIKit

class PhotoListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImage.layer.cornerRadius = thumbnailImage.bounds.width / 10
        thumbnailImage.clipsToBounds = true
    }
}
