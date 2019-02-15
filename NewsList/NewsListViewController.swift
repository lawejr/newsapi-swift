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
    
    var nextRequestPage: Int? = 1
    var searchController: UISearchController!
    var resultsController: SearchResultsController!
    weak var fetchTimer: Timer?
    
    private var news: [News] = []
    
    @objc
    func requestNews() {
        NewsTransport.getTop(page: self.nextRequestPage).then { result in
            if self.news.first?.url != result.articles.first?.url {
                self.news = result.articles
                self.newsTableView.reloadData()
                self.resultsController.news = result.articles
            }
        }
    }
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scroll")
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            print("bottom edge")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsController = SearchResultsController()
        
        requestNews()
        
        fetchTimer?.invalidate()
        fetchTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(requestNews), userInfo: nil, repeats: true)
        
        newsTableView.register(UINib(resource: R.nib.newsCell), forCellReuseIdentifier: R.reuseIdentifier.newsCell.identifier)
        newsTableView.rowHeight = 320
        
        searchController = UISearchController(searchResultsController: resultsController)
        
        let searchBar = searchController.searchBar
        
        searchBar.placeholder = "Поиск"
        searchBar.sizeToFit()
        
        newsTableView.tableHeaderView = searchBar
        
        searchController.searchResultsUpdater = resultsController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fetchTimer?.invalidate()
    }
}

