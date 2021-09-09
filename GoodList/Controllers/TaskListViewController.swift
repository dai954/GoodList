//
//  TaskListViewController.swift
//  GoodList
//
//  Created by 石川大輔 on 2021/09/09.
//

import UIKit
import RxSwift

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    
    let segmentedControl: UISegmentedControl = {
        let items = ["All", "High", "Midium", "Low"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .white
        control.layer.borderWidth = 0.5
        control.layer.borderColor = UIColor.blue.cgColor
        control.selectedSegmentTintColor = .blue
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        segmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 40, bottom: 0, right: 40))
        view.addSubview(tableView)
        tableView.anchor(top: segmentedControl.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        navSetup()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    private func navSetup() {
        navigationItem.title = "GoodList"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc private func addButtonPressed() {
        
        navigationController?.pushViewController(AddTaskViewController(), animated: true)
    }
}
