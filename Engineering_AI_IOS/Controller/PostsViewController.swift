//
//  PostsViewController.swift
//  Engineering_AI_IOS
//
//  Created by Swaminath Kosetty on 04/02/20.
//  Copyright © 2020 Ojas. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var postsTableView: UITableView!
     // MARK: - VariableDeclaration
    var postModelArray = [PostModel]()
    var selectedCount = 0
    var pageCount = 1
    var totalPage = 1
    var spinner: UIActivityIndicatorView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "PostsTableViewCell", bundle: nil)
        postsTableView.register(nib, forCellReuseIdentifier: "PostsTableViewCell")
        postsTableView.tableFooterView = UIView()
        postsTableView.estimatedRowHeight = 45
        refreshControl.attributedTitle = NSAttributedString(string: "fetching data")
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        postsTableView.addSubview(refreshControl)
        self.title = "Selected Posts: \(selectedCount)"
        spinner = self.setUpSpinner(style: .gray)
    }
    override func viewDidAppear(_ animated: Bool) {
        guard Reachability.isConnectedToNetwork() else {
            self.showAlert(title: "Check internet connection")
            return
        }
        self.showSpinner(destination: .center, activityIndicator: spinner)
        fetchData()
    }
    // MARK: - RefreshAction
    @objc func refreshAction(){
        guard Reachability.isConnectedToNetwork() else {
            self.showAlert(title: "Check internet connection")
            return
        }
        pageCount = 1
        selectedCount = 0
        self.title = "Selected Posts: \(selectedCount)"
        fetchData()
    }
    // MARK: - FetchData
    func fetchData() {
        getPosts { [weak self] in
            DispatchQueue.main.async {
                self?.hideSpinner(activityIndicator: self!.spinner)
                if self!.refreshControl.isRefreshing {
                    self!.refreshControl.endRefreshing()
                }
                self?.postsTableView.reloadData()
            }
        }
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postModelArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "PostsTableViewCell", for: indexPath) as! PostsTableViewCell
        cell.updateCell(postModel: postModelArray, indexPath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
     // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postModelArray[indexPath.row].switchStatus = !postModelArray[indexPath.row].switchStatus
        let indexPath = IndexPath.init(row: indexPath.row, section: 0)
        postsTableView.reloadRows(at: [indexPath], with: .none)
        self.selectedCount = postModelArray.filter{$0.switchStatus == true}.count
        self.title = "Selected Posts: \(selectedCount)"
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == postModelArray.count - 1 {
            if totalPage > pageCount {
                pageCount += 1
                postsTableView.tableFooterView = spinner
                self.showSpinner(destination: .bottom, activityIndicator: spinner)
                fetchData()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    // MARK: - ServiceCalling
    func getPosts(complitionHandeler: @escaping()-> Void) {
        ServiceManager.shared.getDetailsFromServer(url: base_url, pageCount: pageCount, totalPage: totalPage) { (response, serverResponse) in
            switch serverResponse {
            case .success :
                let posts = response?["hits"] as? [Any]
                self.totalPage = response?["nbPages"] as? Int ?? 0
                let intialPosts = PostModel.getDicFromServerArray(serverArray: posts as? [[String: Any]] ?? [["": ""]])
                self.postModelArray = self.pageCount == 1 ? intialPosts : self.postModelArray + intialPosts
            case .badResponse:
                self.showAlert(title: "Error")
                //print("Not readable")
            case .failure:
                self.showAlert(title: "Error")
                //print("Error")
            }
            complitionHandeler()
        }
    }
}
