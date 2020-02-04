//
//  Constants.swift
//  Engineering_AI_IOS
//
//  Created by Swaminath Kosetty on 04/02/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation

let base_url = "https://hn.algolia.com/api/v1/search_by_date?tags=story&page="
struct ServerKeys {
    static let keyTitle = "title"
    static let keyCreatedDate = "created_at"
}
enum ServerResponse {
    case success
    case badResponse
    case failure
}
enum Destination {
    case bottom
    case center
}
