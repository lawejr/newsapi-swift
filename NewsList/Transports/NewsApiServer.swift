//
//  NewsApiServer.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

import Moya

protocol NewsApiServer: TargetType { }

extension NewsApiServer {
    
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Authorization": Constants.newsApiKey]
    }
    
}

protocol BaseTransport {
    
    associatedtype Domain: NewsApiServer
    
    static var provider: MoyaProvider<Domain> { get }
    
}


extension BaseTransport {
    
    static func request<T: Decodable>(_ method: Domain, with promise: Promise<T>) {
        provider.request(method) { response in
            switch response {
                
                case .success(let response):
                    if response.statusCode >= 200 && response.statusCode < 300 {
                        if let object = try? Instances.jsonDecoder.decode(T.self, from: response.data) {
                            promise.then(object)
                        } else {
                            print(response.description)
                            
                            if let string = try? response.mapString() {
                                print(string)
                            }
                        }
                    } else {
                        let error = ServerError()
                        
                        promise.catch(error)
                    }
                
                case .failure(let error):
                    print(error)
                    
                    promise.catch(error)
                
            }
        }
    }
}
