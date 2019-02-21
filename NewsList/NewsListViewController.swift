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
    
    @IBOutlet var newsTableView: UITableView!
    
    var nextRequestPage: Int? = 1
    var hasActiveRequest: Bool = false
    var searchController: UISearchController!
    var resultsController: SearchResultsController!
    weak var fetchTimer: Timer?
    
    private var news: [News] = []
    
    private func filter(articles: [News]) -> [News] {
        return articles.filter() { article in
            return !news.contains(where: { item in item.url == article.url })
        }
    }
    
    @objc
    func handleScrollNews() {
        guard let page = self.nextRequestPage else { return }
        
        self.hasActiveRequest = true
        NewsTransport.getTop(page: page).then { result in
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
            
            self.newsTableView.reloadData()
            self.resultsController.news = self.news
            self.hasActiveRequest = false
        }
    }
    
    @objc
    func fetchNews(isFirst: Bool = false) {
        if (!hasActiveRequest) {
            hasActiveRequest = true
            
            NewsTransport.getTop(page: 1).then { result in
                if isFirst {
                    self.news = []
                }
                
                if self.news.count == 0 {
                    self.news.append(contentsOf: result.articles)
                    self.newsTableView.reloadData()
                } else {
                    let newArticles = self.filter(articles: result.articles)
                    
                    if newArticles.count > 0 {
                        self.news.insert(contentsOf: self.filter(articles: result.articles), at: 0)
                        self.newsTableView.reloadData()
                    }
                }
                self.hasActiveRequest = false
            }
        }
    }
    
    @objc
    func applicationWillResignActive(notification: Notification) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let savedNewsCount = self.news.count <= NewsTransport.pageSize ? self.news.count : NewsTransport.pageSize
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: News.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        
        for i in 0 ..< savedNewsCount {
            let article = self.news[i]
            let objectForSave = NSEntityDescription.insertNewObject(forEntityName: News.entityName, into: context)
            
            objectForSave.setValue(article.title, forKey: News.titleKey)
        }
        
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.newsCell.identifier) as? NewsCell
        let newsItem = news[indexPath.row]
        let url = URL(string: newsItem.imageUrl ?? "")
        
        cell?.title = newsItem.title ?? ""
        cell?.contentText = newsItem.text ?? ""
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
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 && nextRequestPage != nil && !hasActiveRequest {
            hasActiveRequest = true
            
            handleScrollNews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let арр = UIApplication.shared
        let appDelegate = арр.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: News.entityName)
        
        do {
            if let objects = try context.fetch(request) as? [NewsEntity], self.news.count == 0 {
                for object in objects {
                    self.news.append(News.fromCoreData(data: object))
                }
                self.newsTableView.reloadData()
            }
        } catch {
            // Перехват ошибки, сгенерированной методом executeFetchRequest()
            print("There was an error in executeFetchRequest(): \(error)")
        }
        
        resultsController = SearchResultsController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: арр)
        
        fetchNews(isFirst: true)
        
        fetchTimer?.invalidate()
        fetchTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fetchNews), userInfo: nil, repeats: true)
        
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

