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
    
    private var items: [Item] = []
    private var task: URLSessionTask?
    private var idx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.searchTextField.textColor = .white
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let detailVC = segue.destination as? DetailViewController
            detailVC?.item = items[idx!]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let repo = items[indexPath.row]
        cell.textLabel?.text = repo.fullName
        cell.detailTextLabel?.text = repo.language
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
        // 初期のテキストを消す処理
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
                
            guard let data = data, err == nil else {
                print(err ?? "Unknown error")
                return
            }

            do {
                let searchRepositories = try JSONDecoder().decode(SearchResponse.self, from: data)
                    DispatchQueue.main.async {
                        self?.items = searchRepositories.items
                        self?.tableView.reloadData()
                    }
                } catch let error {
                    print(error)
                    return
                }
        }
        task?.resume()
    }
}
