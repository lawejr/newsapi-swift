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
            parameters["pageSize"] = NewsTransport.pageSize
            parameters["page"] = page
        default:
            break
        }
        
        return Task.requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
}

final class NewsTransport: BaseTransport {
    static let pageSize = 5
    static var provider = MoyaProvider<NewsDomain>()
    
    static func getTop(page: Int?) -> Promise<NewsApiResponse<News>> {
        return Promise { promise in
            let method = NewsDomain.getTop(page: page ?? 1)
            
            self.request(method, with: promise)
        }
    }
    
}
