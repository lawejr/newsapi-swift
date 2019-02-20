//
//  News.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

struct News: Decodable {
    static let entityName = "NewsEntity"
    
    let title: String?
    let text: String?
    let url: String?
    let imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case text = "description"
        case url
        case imageUrl = "urlToImage"
    }
}
