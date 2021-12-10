//
//  ViewController.swift
//  CitiesOfTheWorld
//
//  Created by One Bank Ltd on 7/12/21.
//

import UIKit
import RealmSwift
import Alamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    static var cities : Results<CityDto>?
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage : Int = 1
    var totalPage : Int = 1
    var query : String = ""
    private var itemsToken: NotificationToken?
    
    // Open the default realm.
    let realm = try! Realm()
    var searchController : UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
       searchController  = UISearchController(searchResultsController: nil)
        
        searchBar.addSubview(searchController.searchBar)
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        
        tableView.dataSource = self
        tableView.delegate =  self
        searchController.searchBar.delegate  = self
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        
        MainViewController.cities = CityDto.all()
        
        
    }
    
    
    
    @objc private func refreshData(){
        
        currentPage = 1
        // cities.removeAll()
      
        
        CitiesApiManager.shared.sessionManager.sessionConfiguration.urlCache?.removeAllCachedResponses()
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        fetchAndDisplayCities()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemsToken = MainViewController.cities?.observe(on: DispatchQueue.main, { changes in
            switch changes {
            case .initial:
                self.tableView?.reloadData()
            case .update(let obj, let deletions, let insertions, let updates):
                self.tableView?.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
                
            case .error:
                break
                
            }
            
        })
        //Avoid reloading repositories if active search is in place
        if let searchText = searchBar?.text, !searchText.isEmpty {
            return
        }
        fetchAndDisplayCities()
    }
    
    func fetchAndDisplayCities(){
        //     loadingIndicator.startAnimating()
        CitiesApiManager.shared.searchCities(page: currentPage, include: "country", query: query) {  result in
            self.tableView?.refreshControl?.endRefreshing()
            switch result {
            case .success( let data):
                
                //self.cities.append(contentsOf: data.items ?? [])
                for item in data.items ?? [] {
                    CityDto.add(cityName: item.local_name!, countryName: (item.country?.name!)!, lat: item.lat ?? 0.0, lon: item.lng ?? 0.0)
                }
                self.totalPage = data.pagination?.total ?? 1
                self.loadingIndicator.stopAnimating()
                
                //   self.tableView.reloadData()
            case .failure(_):
                print("Bad Response")
            }
            
            
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        itemsToken?.invalidate()
    }
}

extension MainViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainViewController.cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  currentPage < totalPage  && indexPath.row == MainViewController.cities?.count ?? 0 - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading", for: indexPath)
            return cell
        }else {
          
            
              let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityViewCell
            
            if(MainViewController.cities!.count > indexPath.row){
                cell.title.text = (MainViewController.cities?[indexPath.row].cityName) ?? ""
                cell.subTitle.text = MainViewController.cities?[indexPath.row].countryName
            }
            return cell
            
            
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75 // the height you want
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch new data if user scroll to the last cell
       // print(" \(indexPath.row) will display \(cities?.count ?? 0)" )
        
        if  currentPage < totalPage  && indexPath.row == (MainViewController.cities?.count ?? 0 ) - 1 {
            currentPage = currentPage + 1
            if(MainViewController.cities?.count ?? 0 >= 15){
                fetchAndDisplayCities()
            }
        }else{
            
        }
        
    }
    
    
}


extension MainViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       
        guard let query = searchBar.text else {
            return
        }
        
       
        
        loadingIndicator.startAnimating()
        self.query = query
        CitiesApiManager.shared.searchCities(page: 1, include: "country", query: query) { res in
            switch res {
            case .success(let data):
                //   self.cities = data.items ?? []
                self.currentPage = 1
                self.totalPage = data.pagination?.total ?? 1
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                for item in data.items ?? [] {
                    CityDto.add(cityName: item.local_name!, countryName: (item.country?.name!)!,  lat: item.lat ?? 0.0 , lon: item.lng ?? 0.0)
                }
                
                
                self.loadingIndicator.stopAnimating()
                //        self.tableView.reloadData()
            case .failure(_):
                print("bad res")
                
            }
            
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cleared")
               searchBar.text = nil
               searchBar.resignFirstResponder()
               self.query = ""
               fetchAndDisplayCities()
    }
    
    func hideKeyboardWithSearchBar(bar:UISearchBar) {
        bar.resignFirstResponder()
    }
}
extension IndexPath {
    static func fromRow(_ row: Int) -> IndexPath {
        return IndexPath(row: row, section: 0)
    }
}
extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        beginUpdates()
        deleteRows(at: deletions.map(IndexPath.fromRow), with: .automatic)
        insertRows(at: insertions.map(IndexPath.fromRow), with: .automatic)
        reloadRows(at: updates.map(IndexPath.fromRow), with: .automatic)
        endUpdates()
    }
}
