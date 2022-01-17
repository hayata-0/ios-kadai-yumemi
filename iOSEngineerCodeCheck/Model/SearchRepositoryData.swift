//
//  SearchRepositoryData.swift
//  iOSEngineerCodeCheck
//
//  Created by 大野颯太 on 2022/01/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

struct SearchResponse: Decodable {
    let items: [Item]

    private enum CodingKeys: String, CodingKey {
        case items
    }
}

struct Item: Decodable {
    let id: Int
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int

    let owner: Owner

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "full_name"
        case language = "language"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case owner = "owner"
    }
}

struct Owner: Decodable {
    let avatarUrl: String

    private enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
