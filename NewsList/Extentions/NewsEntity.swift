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
    static let imageUrlKey = "imageUrl"
    
    func configureFrom(news: News) {
        self.setValue(news.title, forKey: NewsEntity.titleKey)
        self.setValue(news.text, forKey: NewsEntity.textKey)
        self.setValue(news.url, forKey: NewsEntity.urlKey)
        self.setValue(news.imageUrl, forKey: NewsEntity.imageUrlKey)
    }
    
}
