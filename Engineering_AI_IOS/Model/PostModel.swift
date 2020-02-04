//
//  PostModel.swift
//  Engineering_AI_IOS
//
//  Created by Swaminath Kosetty on 04/02/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import Foundation

class PostModel {
    var title = ""
    var createdDate = ""
    var switchStatus = false
    init(dictionary: [String: Any]) {
        if let aTitle = dictionary[ServerKeys.keyTitle] {
            self.title = aTitle as? String ?? ""
        }
        if let aCreatedDate = dictionary[ServerKeys.keyCreatedDate] {
            self.createdDate = aCreatedDate as? String ?? ""
        }
    }
    public class func getDicFromServerArray(serverArray: [[String: Any]])-> [PostModel] {
        var posts = [PostModel]()
        for eachObj in serverArray {
            let modelObj = PostModel.init(dictionary: eachObj)
            posts.append(modelObj)
        }
        return posts
    }
}
