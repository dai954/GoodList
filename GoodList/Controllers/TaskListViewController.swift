//
//  TaskListViewController.swift
//  GoodList
//
//  Created by 石川大輔 on 2021/09/09.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
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
        
        segmentedControl.addTarget(self, action: #selector(priorityValueChanged), for: .valueChanged)
        navSetup()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredTasks[indexPath.row].title
        return cell
    }
    
    private func navSetup() {
        navigationItem.title = "GoodList"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
    }
    
    @objc private func addButtonPressed() {
        
        let addTaskVC = AddTaskViewController()
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                
                let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
                
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                
                self.filterTasks(by: priority)
                
            }).disposed(by: disposeBag)
        
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    @objc private func priorityValueChanged(segmentedControl: UISegmentedControl) {
        
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTasks(by: priority)
        
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            
            self.tasks
                .map { tasks in
                    return tasks.filter { $0.priority == priority }
                }.subscribe(onNext: { [weak self] tasks in
                    self?.filteredTasks = tasks
                    self?.updateTableView()
                    print(tasks)
                }).disposed(by: disposeBag)
            
        }
        
    }
}
