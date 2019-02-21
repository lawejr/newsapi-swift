//
//  News.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

struct News: Decodable {
    static let entityName = "NewsEntity"
    static let titleKey = "title"
    static let textKey = "text"
    static let urlKey = "url"
    static let imageUrlKey = "imageUrl"
    
    static func fromCoreData(data: NewsEntity) -> News {
        return News(title: data.title, text: data.text, url: data.url, imageUrl: data.imageUrl)
    }
    
    init(title: String?, text: String?, url: String?, imageUrl: String?) {
        self.title = title
        self.text = text
        self.url = url
        self.imageUrl = imageUrl
    }
    
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
