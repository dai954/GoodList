//
//  NewViewController.swift
//  GoodList
//
//  Created by 石川大輔 on 2021/09/09.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    let prioritySegmentedControl: UISegmentedControl = {
        let items = ["High", "Midium", "Low"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.layer.borderWidth = 0.5
        control.layer.borderColor = UIColor.blue.cgColor
        control.backgroundColor = .white
        control.selectedSegmentTintColor = .blue
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], for: .normal)
        return control
    }()
    
    let taskTitletextField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .lightGray
        return field
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(prioritySegmentedControl)
        view.addSubview(taskTitletextField)
        
        prioritySegmentedControl.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 60, bottom: 0, right: 60))
        taskTitletextField.translatesAutoresizingMaskIntoConstraints = false
        taskTitletextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        taskTitletextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        taskTitletextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        setupNav()
    }
    
    private func setupNav() {
        navigationItem.title = "Add Task"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonPressed))
    }
    
    @objc private func saveButtonPressed() {
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex),
              let title = taskTitletextField.text else { return }
        
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.navigationController?.popViewController(animated: true)
    }
}
