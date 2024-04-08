//
//  UITableViewCell+CellIdentifier.swift
//  WemoTest
//
//  Created by WEI-TSUNG CHENG on 2024/2/7.
//

import UIKit

extension UITableViewCell {
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
