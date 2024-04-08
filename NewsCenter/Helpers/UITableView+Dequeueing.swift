//
//  UITableView+Dequeueing.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/7.
//


import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}



