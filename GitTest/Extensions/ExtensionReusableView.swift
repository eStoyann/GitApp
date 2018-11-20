//
//  ExtansionReusableView.swift
//  GitTest
//
//  Created by Evgeniy on 10/30/18.
//  Copyright © 2018 com.gmail.1001stoyanhik. All rights reserved.
//

import Foundation
import UIKit

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String { return String(describing: self) }
}
