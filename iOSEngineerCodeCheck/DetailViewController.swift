//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var wathcersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var openIssuesCountLabel: UILabel!
    
    var repo = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsCountLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        wathcersCountLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        openIssuesCountLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
        
    }
    
    func getImage(){
        
        titleLabel.text = repo["full_name"] as? String
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async { [weak self] in
                        self?.profileImageView.image = img
                    }
                }.resume()
            }
        }
        
    }
    
}
