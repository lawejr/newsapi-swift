//
//  SearchResultsControllerTableViewController.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 11/02/2019.
//  Copyright © 2019 Aleksandr Kalinin. All rights reserved.
//

import UIKit

class SearchResultsController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    var tableView = UITableView()
    var news: [News] = []
    var filteredNews: [News] = []
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            filteredNews.removeAll()
            
            if !searchString.isEmpty {
                filteredNews = news.filter({ $0.title?.lowercased().contains(searchString.lowercased()) ?? false })
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let leadingConstraint = tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = tableView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            topConstraint,
            bottomConstraint
        ])
        
        tableView.register(UINib(resource: R.nib.newsCell), forCellReuseIdentifier: R.reuseIdentifier.newsCell.identifier)
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell.identifier) as? NewsCell {
            let newsItem = filteredNews[indexPath.row]
            
            cell.configure(from: newsItem)
            
            return cell
        }
        
        return UITableViewCell()
    }

}
