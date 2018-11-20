//
//  ExtansionNibLoadableView.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import UIKit

extension NibLoadableView where Self: UIView {
    static var nibName: String { return String(describing: self) }
}
