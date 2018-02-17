//
//  ViewController.swift
//  Effective Swift App
//
//  Created by Ashif Ismail on 14/02/18.
//  Copyright © 2018 Ashif Ismail. All rights reserved.
//

import UIKit
import Moya


class ViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movies = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        movieTableView.delegate = self

        // MARK: Fetch Latest Movies from API
        MovieService.getLatestMovies(page: 1) { (movieResponse) in
            self.movies = movieResponse.results
            self.movieTableView.reloadData()
        }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableCell
        cell.movieTitle.text = movies[indexPath.row].title
        cell.movieOverview.text = movies[indexPath.row].overview
        cell.movieRating.text = String(movies[indexPath.row].voteAverage)
        cell.movieReleaseDate.text = movies[indexPath.row].releaseDate
        cell.movieImage.downloadedFrom(link:"https://www.android.com/static/2016/img/share/andy-lg.png")
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
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

