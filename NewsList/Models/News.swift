//
//  News.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 27/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

struct News: Decodable {
    let title: String?
    let description: String?
    let url: String?
    let imageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case url
        case imageUrl = "urlToImage"
    }
}
