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
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = item {
            configure(item: item)
        }
        
    }
    
    private func configure(item: Item) {
        
        languageLabel.text = item.language.map { "Written in \($0)" }
        starsCountLabel.text = "\(item.stargazersCount) stars"
        wathcersCountLabel.text = "\(item.watchersCount) watchers"
        forksCountLabel.text = "\(item.forksCount) forks"
        openIssuesCountLabel.text = "\(item.openIssuesCount) open issues"
        titleLabel.text = item.fullName
        
        if let ownerUrl = URL(string: item.owner.avatarUrl) {
            getImage(url: ownerUrl)
        }
    }
    
    private func getImage(url: URL){
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data, err == nil else {
                print(err ?? "Unknown error")
                return
            }

            if let avatarImage = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.profileImageView.image = avatarImage
                }
            }
        }.resume()
    }
}
