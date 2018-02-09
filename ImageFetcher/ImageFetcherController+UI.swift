//
//  ImageFetcherController+UI.swift
//  ImageFetcher
//
//  Created by Alex Akrimpai on 09/02/2018.
//  Copyright © 2018 CodingWarrior. All rights reserved.
//

import UIKit

extension ImageFetcherController {
    internal func setupView() {
        guard let cw = collectionView else { return }
        
        cw.register(ImageFetcherCell.self, forCellWithReuseIdentifier: cellId)
        cw.backgroundColor = .white
        navigationItem.title = "Images"
        
        cw.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: cw.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: cw.centerYAnchor, constant: -50).isActive = true
    }
    
}
