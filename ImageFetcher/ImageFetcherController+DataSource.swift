//
//  ImageFetcherController+DataSource.swift
//  ImageFetcher
//
//  Created by Alex Akrimpai on 09/02/2018.
//  Copyright © 2018 CodingWarrior. All rights reserved.
//

import UIKit

extension ImageFetcherController {    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImages
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageFetcherCell
        
        guard let url = URL(string: self.getImageUrlFor(pos: indexPath.row)) else { return cell }
        
        let data = try? Data(contentsOf: url)
        
        if let data = data, let image = UIImage(data: data) {
            cell.set(image: image)

            if let selectedPhoto = self.selectedPhoto, selectedPhoto.row == indexPath.row {
                selectedPhoto.imageView.set(image: image)
            }
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageFullScreenViewController = ImageFullScreenViewController()
    
        let image = (collectionView.cellForItem(at: indexPath) as! ImageFetcherCell).imageView.image
        
        imageFullScreenViewController.set(image: image)
        
        selectedPhoto = (indexPath.row, imageFullScreenViewController)
        
        navigationController?.pushViewController(imageFullScreenViewController, animated: true)
    }
}
