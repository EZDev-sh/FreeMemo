//
//  File.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/11.
//  Copyright © 2020 EZDev. All rights reserved.
//

// 기존 데이터 모델
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

// RealmSwift를 사용한 데이터 모델
// create by EZDev on 2020.03.15
//
//import RealmSwift
//
//class Memo: Object {
//    @objc dynamic var title: String = ""
//    @objc dynamic var content: String = ""
//    
//    let imageArray: List<Picture> = List<Picture>()
//}
//
//class Picture: Object {
//    @objc dynamic var name: String = ""
//    @objc dynamic var imageData: Data = Data()
//}
