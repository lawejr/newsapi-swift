//
//  NewsTransport.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

import Moya

enum NewsDomain: NewsApiServer {
    
    case getTop(page: Int, pageSize: Int)
    
    var path: String {
        switch self {
        case .getTop:
            return "/top-headlines"
        }
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .getTop(let page, let pageSize):
            parameters["country"] = "ru"
            parameters["pageSize"] = pageSize
            parameters["page"] = page
        }
        
        return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}

final class NewsTransport: BaseTransport {
    static let defaultPageSize = 5
    static var provider = MoyaProvider<NewsDomain>()
    
    static func getTop(page: Int?, pageSize: Int = NewsTransport.defaultPageSize) -> Promise<NewsApiResponse<News>> {
        return Promise { promise in
            let method = NewsDomain.getTop(page: page ?? 1, pageSize: pageSize)
            
            request(method, with: promise)
        }
    }
    
}
