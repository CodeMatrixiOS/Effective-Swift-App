//
//  DetailsViewController.swift
//  Effective Swift App
//
//  Created by Ashif Ismail on 17/02/18.
//  Copyright © 2018 Ashif Ismail. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var movieObj: Result? 
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        movieLabel.text = movieObj?.title
        movieDesc.text = movieObj?.overview
        moviePoster.downloadedFrom(link: "\(AppConstants.BASE_IMAGE_URL)\(movieObj?.backdropPath)")
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
