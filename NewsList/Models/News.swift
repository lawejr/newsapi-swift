//
//  News.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

struct News: Decodable {
    static func fromCoreData(data: NewsEntity) -> News {
        return News(title: data.title, text: data.text, url: data.url, imageURL: data.imageURL)
    }
    
    let title: String?
    let text: String?
    let url: String?
    let imageURL: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case text = "description"
        case url
        case imageURL = "urlToImage"
    }
}
