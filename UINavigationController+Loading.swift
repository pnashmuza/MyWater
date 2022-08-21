//
//  UINavigationController+Loading.swift
//  Gargoyle
//
//  Created by panashem on 1/1/21.
//  Copyright © 2021 PanasheMuzangaza. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem
{
    func showLoading() {
        if isShowingLoading() {return}
        let indicatorItem = UIActivityIndicatorView(style: .large)
        indicatorItem.color = UIColor.systemTeal
        indicatorItem.startAnimating()
        let button = UIBarButtonItem(customView: indicatorItem)
        var currentItems = rightBarButtonItems ?? []
        currentItems.append(button)
        setRightBarButtonItems(currentItems, animated: true)
    }
    
    func stopLoading() {
        if !isShowingLoading() {return}
        var currentItems = rightBarButtonItems
        currentItems?.removeAll(where: {$0.customView is UIActivityIndicatorView})
        setRightBarButtonItems(currentItems, animated: true)
    }
    
    private func isShowingLoading() -> Bool {
        let rightItems = self.rightBarButtonItems
        return rightItems?.contains(where: {$0.customView is UIActivityIndicatorView}) ?? false
    }
}
