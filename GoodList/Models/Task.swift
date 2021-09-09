//
//  Task.swift
//  GoodList
//
//  Created by 石川大輔 on 2021/09/09.
//

import Foundation

enum Priority: Int {
    case heigh
    case midium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
