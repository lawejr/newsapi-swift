//
//  SearchResultsControllerTableViewController.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 11/02/2019.
//  Copyright © 2019 Aleksandr Kalinin. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    var news: [News] = []
    var filteredNews: [News] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            filteredNews.removeAll(keepingCapacity: true)
            
            if !searchString.isEmpty {
                let filter: (News) -> Bool = { newsItem in
                    let range = newsItem.title?.range(of: searchString, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
                    
                    return range != nil
                }
                
                filteredNews = news.filter(filter)
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(resource: R.nib.newsCell), forCellReuseIdentifier: R.reuseIdentifier.newsCell.identifier)
        tableView.rowHeight = 320
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell.identifier) as? NewsCell
        let newsItem = filteredNews[indexPath.row]
        let url = URL(string: newsItem.imageURL ?? "")
        
        cell?.title = newsItem.title ?? ""
        cell?.contentText = newsItem.text ?? ""
        cell?.previewImage.kf.setImage(with: url, placeholder: R.image.placeholder())
        
        return cell ?? UITableViewCell()
    }

}
