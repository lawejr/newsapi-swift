//
//  NewsApiResponse.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 29/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

struct NewsApiResponse<T: Decodable>: Decodable {
    let status: String
    let articles: [T]
    let totalResults: Int
}
