//
//  File.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/11.
//  Copyright © 2020 EZDev. All rights reserved.
//

import Foundation
import UIKit

class Model {
    var title: String?
    var content: String?
    var images: [UIImage]?
    var imageName: [String]?
}

class DataMgr {
    static let shared: DataMgr = DataMgr()
    
    private init() {}
    
    var memoList = [Model]()
}
