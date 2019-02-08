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
    
    case getTop
    
    var path: String {
        switch self {
        case .getTop:
            return "/top-headlines"
        default:
            return ""
        }
    }
    
}

final class NewsTransport: BaseTransport {
    
    static var provider = MoyaProvider<NewsDomain>()
    
    static func getTop() -> Promise<NewsApiResponse<News>> {
        return Promise { promise in
            let method = NewsDomain.getTop
            
            self.request(method, with: promise)
        }
    }
    
}
