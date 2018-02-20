//
//  MovieService.swift
//  Effective Swift App
//
//  Created by Ashif Ismail on 17/02/18.
//  Copyright © 2018 Ashif Ismail. All rights reserved.
//

import Foundation
import Moya

class MovieService {
    
    static let movieProvider = MoyaProvider<MoviewEndpoints>(/*plugins: [NetworkLoggerPlugin()]*/)
    
    //MARK: API call to get Latest Movies
    static func getLatestMovies(page: Int,completion: @escaping (Movies) -> ()) {
        movieProvider.request(.newmovies(pageNo: page)) { (result) in
            switch result {
            case .success(let response):
                if let movieResults = Movies.init(data: response.data) {
                    completion(movieResults)
                } else {
                    print("error loading data")
                }
                
            case .failure(let error):
                print(error.errorDescription as Any)
            }
        }
    }
    
    //MARK: API call to get particular movie details
    static func getMovieDetails(movieId: Int,completion: @escaping (Details) -> ()) {
        movieProvider.request(.movieDetails(movieId: 337167)) { (result) in
            switch result {
            case .success(let response):
                if let movieDetails = Details.init(data: response.data) {
                    completion(movieDetails)
                } else {
                    print("error loading data")
                }
            case .failure(let error):
                print(error.errorDescription as Any)
            }
        }
    }
}
