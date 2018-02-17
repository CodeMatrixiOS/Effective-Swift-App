//
//  MovieEndpoints.swift
//  Effective Swift App
//
//  Created by Ashif Ismail on 16/02/18.
//  Copyright © 2018 Ashif Ismail. All rights reserved.
//

import Foundation
import Moya

enum MoviewEndpoints {
    case newmovies(pageNo: Int)
    case movieDetails(movieId: Int)
}

extension MoviewEndpoints : TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        return URL(string: AppConstants.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .newmovies:
            return "now_playing"
        case .movieDetails(let movieId):
            return "\(movieId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .newmovies:
            return .get
        case .movieDetails:
            return .get
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .newmovies(let pageno):
            return .requestParameters(parameters: ["page":pageno,"api_key":AppConstants.API_KEY], encoding: URLEncoding.queryString)
        case .movieDetails:
            return .requestParameters(parameters: ["api_key":AppConstants.API_KEY], encoding: URLEncoding.queryString)
        }
    }
}
