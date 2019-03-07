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
import CoreData

class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var newsTableView: UITableView!
    
    private var nextRequestPage: Int? = 1
    private var hasActiveRequest = false
    private var resultsController = SearchResultsController()
    private var searchController: UISearchController?
    private var fetchTimer: Timer?
    private var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.register(UINib(resource: R.nib.newsCell), forCellReuseIdentifier: R.reuseIdentifier.newsCell.identifier)
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = resultsController
        
        if let searchBar = searchController?.searchBar {
            searchBar.placeholder = "Поиск"
            searchBar.sizeToFit()
        }
        
        let objects = CoreDataHelper.shared.fetchRecordsFor(entity: NewsEntity.entityName)
        
        if let objects = objects as? [NewsEntity], news.isEmpty {
            news = objects.map { News.fromCoreData(data: $0) }
            
            updateUI()
        }
        
        fetchNews(isFirst: true)
        
        fetchTimer?.invalidate()
        fetchTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fetchNews), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        fetchTimer?.invalidate()
    }
    
    private func filter(articles: [News]) -> [News] {
        return articles.filter() { article in
            return !news.contains(where: { $0.url == article.url })
        }
    }
    
    private func updateUI() {
        resultsController.news = news
        newsTableView.reloadData()
    }
    
    private func calculateRequestPageSize() -> Int {
        let cellHeight = newsTableView.visibleCells.first?.frame.height ?? 320
        let viewHeight = newsTableView.bounds.height
        
        return Int(viewHeight / cellHeight * 3)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = newsTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell.identifier) as? NewsCell {
            let newsItem = news[indexPath.row]
            
            cell.configure(from: newsItem)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = news[indexPath.row].url, let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
        
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchController?.searchBar.bounds.height ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return searchController?.searchBar
        }
        
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let windowHeight = newsTableView.window?.frame.height else { return }
        
        let remainsScroll = newsTableView.contentSize.height - newsTableView.contentOffset.y
        
        if remainsScroll <= windowHeight {
            handleScrollNews()
        }
    }
    
    func save(news: [News]) {
        let pageSize = calculateRequestPageSize()
        let savedNewsCount = news.count <= pageSize ? news.count : pageSize
        
        CoreDataHelper.shared.removeRecordsFor(entity: NewsEntity.entityName)
        
        for i in 0 ..< savedNewsCount {
            let article = news[i]
            
            if let record = CoreDataHelper.shared.createRecordFor(entity: NewsEntity.entityName) as? NewsEntity {
                record.configureFrom(newsItem: article)
                CoreDataHelper.shared.saveContext()
            }
        }
    }
    
    func handleScrollNews() {
        guard !hasActiveRequest else { return }
        guard let page = nextRequestPage else { return }
        
        hasActiveRequest = true
        
        NewsTransport.getTop(page: page, pageSize: calculateRequestPageSize()).then { result in
            if self.news.count == 0 {
                self.news = result.articles
            } else {
                let newArticles = self.filter(articles: result.articles)
                
                if newArticles.count > 0 {
                    self.news.append(contentsOf: newArticles)
                }
            }
            
            if self.news.count < result.totalResults && self.nextRequestPage != nil {
                self.nextRequestPage = (self.nextRequestPage ?? 1) + 1
            } else {
                self.nextRequestPage = nil
            }
            
            self.updateUI()
            self.hasActiveRequest = false
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    @objc
    func fetchNews(isFirst: Bool = false) {
        guard !hasActiveRequest else { return }
        
        hasActiveRequest = true
        
        NewsTransport.getTop(page: 1, pageSize: calculateRequestPageSize()).then { result in
            if isFirst {
                self.news = []
            }
            
            if self.news.count == 0 {
                self.news.append(contentsOf: result.articles)
                self.updateUI()
            } else {
                let newArticles = self.filter(articles: result.articles)
                
                if newArticles.count > 0 {
                    self.news.insert(contentsOf: self.filter(articles: result.articles), at: 0)
                    self.updateUI()
                }
            }
            self.hasActiveRequest = false
            
            self.save(news: self.news)
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
}

