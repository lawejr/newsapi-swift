//
//  NewsEntity.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 21/02/2019.
//  Copyright © 2019 Aleksandr Kalinin. All rights reserved.
//

extension NewsEntity {
    
    static let entityName = "NewsEntity"
    static let titleKey = "title"
    static let textKey = "text"
    static let urlKey = "url"
    static let imageURLKey = "imageURL"
    
    func configureFrom(newsItem: News) {
        setValue(newsItem.title, forKey: NewsEntity.titleKey)
        setValue(newsItem.text, forKey: NewsEntity.textKey)
        setValue(newsItem.url, forKey: NewsEntity.urlKey)
        setValue(newsItem.imageURL, forKey: NewsEntity.imageURLKey)
    }
    
}
