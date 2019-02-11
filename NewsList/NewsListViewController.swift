//
//  ViewController.swift
//  NewsList
//
//  Created by Aleksandr Kalinin on 25/12/2018.
//  Copyright © 2018 Aleksandr Kalinin. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher

class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var newsTableView: UITableView!
    
    var searchController: UISearchController!
    
    private var news: [News] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell.identifier) as? NewsCell
        let newsItem = news[indexPath.row]
        let url = URL(string: newsItem.imageUrl ?? "")
        
        cell?.title = newsItem.title ?? ""
        cell?.contentText = newsItem.description ?? ""
        cell?.previewImage.kf.setImage(with: url, placeholder: R.image.placeholder())
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = news[indexPath.row].url, let url = URL(string: urlString) {
            let svc = SFSafariViewController(url: url)
        
            present(svc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resultsController = SearchResultsController()
        
        NewsTransport.getTop().then { result in
            self.news = result.articles
            self.newsTableView.reloadData()
            resultsController.news = result.articles
        }
        newsTableView.register(UINib(resource: R.nib.newsCell), forCellReuseIdentifier: R.reuseIdentifier.newsCell.identifier)
        newsTableView.rowHeight = 320
        
        searchController = UISearchController(searchResultsController: resultsController)
        
        let searchBar = searchController.searchBar
        
        searchBar.placeholder = "Поиск"
        searchBar.sizeToFit()
        
        newsTableView.tableHeaderView = searchBar
        
        searchController.searchResultsUpdater = resultsController
    }
    
}

