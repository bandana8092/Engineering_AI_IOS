//
//  ServiceManager.swift
//  Engineering_AI_IOS
//
//  Created by Swaminath Kosetty on 04/02/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    func getDetailsFromServer(url: String, pageCount: Int,totalPage: Int, complitionHandler: @escaping([String: Any]?, ServerResponse)->Void) {
        let finalUrl = URL(string: "\(url)\(pageCount)")
        //print(finalUrl!)
        let request = URLRequest.init(url: finalUrl!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (Data, urlResponse, error) in
            if Data == nil {
                //print("No Data Available")
            }else{
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: Data!, options: .mutableContainers) as? [String: Any]
                    guard let responseData = jsonResult else{
                        complitionHandler(nil, .badResponse)
                        return
                    }
                    complitionHandler(responseData, .success)
                } catch {
                     complitionHandler(nil, .failure)
                }
            }
        }
        task.resume()
    }
}
