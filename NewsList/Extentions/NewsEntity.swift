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
        self.setValue(newsItem.title, forKey: NewsEntity.titleKey)
        self.setValue(newsItem.text, forKey: NewsEntity.textKey)
        self.setValue(newsItem.url, forKey: NewsEntity.urlKey)
        self.setValue(newsItem.imageURL, forKey: NewsEntity.imageURLKey)
    }
    
}
