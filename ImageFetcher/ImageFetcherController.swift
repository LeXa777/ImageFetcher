//
//  ImageFetcherController.swift
//  ImageFetcher
//
//  Created by Alex Akrimpai on 09/02/2018.
//  Copyright © 2018 CodingWarrior. All rights reserved.
//

import UIKit

class ImageFetcherController: UICollectionViewController {
    let address = "http://192.168.0.40:8000"
    
    var totalImages = 0
    var selectedPhoto: (row: Int, imageView: ImageFullScreenViewController)?
    
    let cellId = "cellId"
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.color = .black
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        return ai
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchNumberOfImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedPhoto = nil
    }
    
    private func fetchNumberOfImages() {
        guard let url = URL(string: "\(address)/total") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error getting the total count: ", error)
                
                let alert = UIAlertController(title: "Can't connect", message: "Can't connect to the '\(self.address)'.\nPlease make sure you have a server running at that address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.present(alert, animated: true, completion: nil)
                
                return
            }
            
            guard let data = data else { return }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let totImages = responseJSON["totalImages"] as? Int else { return }
                
                DispatchQueue.main.async {
                    self.totalImages = totImages
                    self.collectionView?.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
    }
}

