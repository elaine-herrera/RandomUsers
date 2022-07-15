//
//  UserListViewController.swift
//  RandomUsers
//
//  Created by Alejandro Guerra, DSpot on 9/13/21.
//

import Foundation
import UIKit
import Moya

class UserListViewController: UIViewController{

    //MARK: Dependecy injection 
    var viewModel: UsersViewModel!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        table.prefetchDataSource = self
        table.isHidden = true
        return table
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        activityIndicatorView.startAnimating()
        viewModel.fetchUsers()
    }
    
    func setUpView(){
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableConstraints = [
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(tableConstraints)
        
        let indicatorViewConstraints = [
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(indicatorViewConstraints)
    }
    
    func presentDetails(user: User){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        detailsVC.user = user
        let navigation = UINavigationController.init(rootViewController: detailsVC)
        present(navigation, animated: true)
    }
    
    fileprivate func printMessage(){
        print("Search completed delegate")
    }
}

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell
        if isLoadingCell(for: indexPath) {
            cell?.configure(user: nil)
        } else {
            cell?.configure(user: viewModel.user(at: indexPath.row))
        }
        return cell ?? UITableViewCell()
    }
}

extension UserListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetails(user: viewModel.user(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomTableViewCell.height
    }
}

extension UserListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
    
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
}

extension UserListViewController: UserViewModelDelegate{
    
    /// 
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            activityIndicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        activityIndicatorView.stopAnimating()
        
        let alert = UIAlertController(title: "An error ocurred", message: "\(reason)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

