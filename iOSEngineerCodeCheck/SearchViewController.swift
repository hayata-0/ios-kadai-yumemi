//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var repos: [[String: Any]]=[]
    var task: URLSessionTask?
    var idx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let detailVC = segue.destination as? DetailViewController
            detailVC?.repo = repos[idx!]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let rp = repos[indexPath.row]
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let word = searchBar.text,word.count != 0 else { return }
        
        let urlString = "https://api.github.com/search/repositories?q=\(word)"

        guard let url = URL(string: urlString) else { return }
        task = URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = obj["items"] as? [[String: Any]] {
                    self?.repos = items
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
        }
        task?.resume()
    }
}
