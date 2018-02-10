//
//  ImageFetcherController.swift
//  ImageFetcher
//
//  Created by Alex Akrimpai on 09/02/2018.
//  Copyright © 2018 CodingWarrior. All rights reserved.
//

import UIKit


class ImageFetcherController: UICollectionViewController {
    let localServerAddress = "http://192.168.0.40:3000"
    
    let picsumServerAddress = "https://picsum.photos"
    var picsumPosToImageIdMapper = [Int: Int]()
    
    var address = ""
    
    var totalImages = 0
    var selectedPhoto: (row: Int, imageView: ImageFullScreenViewController)?
    
    let cellId = "cellId"
    
    var screenDimensions: CGSize?
    
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
//        setupUsingLocalServer()
        setupUsingPicsumServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedPhoto = nil
    }
    
    private func setupUsingPicsumServer() {        
        address = picsumServerAddress
        
        guard let url = URL(string: "\(address)/list") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error getting the total count: ", error)
                self.displayInvalidServerAlert()
                return
            }
            
            guard let data = data else { return }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [[String: Any]] {
                
                // Skip first N pics
                let start = 10
                let count = responseJSON.count
                
                var pos = 0
                for i in start..<count {
                    guard let id = responseJSON[i]["id"] as? Int else { return }
                    self.picsumPosToImageIdMapper[pos] = id
                    pos += 1
                }
                
                self.finshedFetchingImagesInfo(totalImages: count - start)
            }
        }.resume()
    }
    
    private func setupUsingLocalServer() {
        address = localServerAddress
        
        guard let url = URL(string: "\(address)/total") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error getting the total count: ", error)
                self.displayInvalidServerAlert()
                return
            }
            
            guard let data = data else { return }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                guard let totalImages = responseJSON["totalImages"] as? Int else { return }
                self.finshedFetchingImagesInfo(totalImages: totalImages)
            }
        }.resume()
    }
    
    private func finshedFetchingImagesInfo(totalImages: Int) {
        DispatchQueue.main.async {
            self.totalImages = totalImages
            self.collectionView?.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func displayInvalidServerAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Can't connect", message: "Can't connect to the '\(self.address)'.\nPlease make sure you have a server running at that address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    internal func getImageUrlFor(pos: Int) -> String {
        let isPicsum = address.contains("picsum")
        
        if isPicsum {
            let id = picsumPosToImageIdMapper[pos]!
            return "\(address)/\(screenDimensions!.width)/\(screenDimensions!.height)/?image=\(id)"
        }
        
        return "\(address)/image/\(pos)"
    }
}

