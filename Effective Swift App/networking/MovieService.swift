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
    
    static let movieProvider = MoyaProvider<MoviewEndpoints>()
    
    static func getLatestMovies(page: Int,completion: @escaping (Movies) -> ()) {
        movieProvider.request(.newmovies(pageNo: page)) { (result) in
            switch result {
            case .success(let response):
                let movieResults = Movies.init(data: response.data)
                completion(movieResults!)
            case .failure(let error):
                print(error.errorDescription as Any)
            }
        }
    }
    
    static func getMovieDetails(movieId: Int,completion: @escaping (Details) -> ()) {
        movieProvider.request(.movieDetails(movieId: 337167)) { (result) in
            switch result {
            case .success(let response):
                if let movieDetails = Details.init(data: response.data) {
                    completion(movieDetails)
                }
            case .failure(let error):
                print(error.errorDescription as Any)
            }
        }
    }
    
}
