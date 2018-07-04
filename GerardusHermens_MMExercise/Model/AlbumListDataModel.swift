//
//  AlbumListDataModel.swift
//  GerardusHermens_MMExercise
//
//  Created by Billionaire on 2018-07-04.
//  Copyright © 2018 GHermens. All rights reserved.
//

import Foundation

class AlbumListDataModel {
    
    // 2 arrays to store web data fetched via JSON
    var albumIdArray = [Int]()
    var albumTitleArray = [String]()
    
    // title array and variable for search function filteringt
    var filteredAlbumIdArray = [Int]()
    var filteredAlbumTitleArray = [String]()
    var willShowSearchResults : Bool = false

}
