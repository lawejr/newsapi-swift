//
//  NewsTransport.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

import Moya

enum NewsDomain: NewsApiServer {
    
    case instance
    
    case getTop(page: Int)
    
    var path: String {
        switch self {
        case .getTop:
            return "/top-headlines"
        default:
            return ""
        }
    }
    
    var task: Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .getTop(let page):
            parameters["country"] = "ru"
            parameters["pageSize"] = 5
            parameters["page"] = page
        default:
            break
        }
        
        return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}

final class NewsTransport: BaseTransport {
    
    static var provider = MoyaProvider<NewsDomain>()
    
    static func getTop(page page: Int = 1) -> Promise<NewsApiResponse<News>> {
        return Promise { promise in
            let method = NewsDomain.getTop(page: page)
            
            self.request(method, with: promise)
        }
    }
    
}
