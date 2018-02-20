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
    @IBOutlet weak var footerView: SearchFooter!
    
    var movies = [Result]()
    var filteredMovies = [Result]()
    var movieObj: Result!
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview settings
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.tableFooterView = footerView
        
        // search controller settings
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        searchController.searchBar.delegate = self
        
        // Place the search bar view to the tableview headerview.
        movieTableView.tableHeaderView = searchController.searchBar
        
        // MARK: Fetch Latest Movies from API
        MovieService.getLatestMovies(page: 1) { (movieResponse) in
            self.movies = movieResponse.results
            self.movieTableView.reloadData()
        }
    }
}

// MARK: Manage Searching
extension ViewController : UISearchBarDelegate,UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        movieTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        movieTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            movieTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredMovies = movies.filter({( movie : Result) -> Bool in
            return movie.title.lowercased().contains(searchText.lowercased())
        })
        
        movieTableView.reloadData()
    }
}

// MARK: Image view extenstion to load from URL
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieTableCell
        if shouldShowSearchResults {
            cell.movieTitle.text = filteredMovies[indexPath.row].title
            cell.movieOverview.text = filteredMovies[indexPath.row].overview
            cell.movieRating.text = String(filteredMovies[indexPath.row].voteAverage)
            cell.movieReleaseDate.text = filteredMovies[indexPath.row].releaseDate
            cell.movieImage.downloadedFrom(link:"\(AppConstants.BASE_IMAGE_URL)\(filteredMovies[indexPath.row].backdropPath)")
        } else {
            cell.movieTitle.text = movies[indexPath.row].title
            cell.movieOverview.text = movies[indexPath.row].overview
            cell.movieRating.text = String(movies[indexPath.row].voteAverage)
            cell.movieReleaseDate.text = movies[indexPath.row].releaseDate
            cell.movieImage.downloadedFrom(link:"\(AppConstants.BASE_IMAGE_URL)\(movies[indexPath.row].backdropPath)")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredMovies.count
        } else {
            return movies.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    // MARK: Take User to Movie Details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowSearchResults {
            movieObj = filteredMovies[indexPath.row]
        } else {
            movieObj = movies[indexPath.row]
        }
        performSegue(withIdentifier: "showMovieDetails", sender: self)
    }
    // MARK: Send Movie Details to DetailsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetails" {
            if let targetVC = segue.destination as? DetailsViewController {
                targetVC.movieObj = movieObj
            }
        }
    }
}
