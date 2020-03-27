//
//  File.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/11.
//  Copyright © 2020 EZDev. All rights reserved.
//

import RealmSwift

// RealmSwift를 사용한 데이터 모델
// create by EZDev on 2020.03.15



class Memo: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    
    let imageArray: List<Picture> = List<Picture>()
}

class Picture: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var imageData: Data = Data()
}

class DataMgr {
    static let shared = DataMgr()
    var realm: Realm?
    var memoList: Results<Memo>?
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 모든 메모를 불러온다.
    // create by EZDev on 2020.03.27
    func loadMemoList() {
        memoList = self.realm?.objects(Memo.self)
    }
    
    // 새로운 메모를 저장한다.
    // create by EZDev on 2020.03.27
    func addNewMemo(memo: Memo) {
        do {
            try realm?.write {
                realm?.add(memo)
            }
        } catch {
            print(error.localizedDescription)
        }

    }
    
    // 메모를 수정한다.
    // create by EZDev on 2020.03.27
    func modifyMemo(memo: Memo, title: String, content: String) {
        do {
            try realm?.write {
                memo.title = title
                memo.content = content
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 메모를 삭제한다.
    // create by EZDev on 2020.03.27
    func deleteMemo(index: Int) {
        do {
            try realm?.write {
                realm?.delete(memoList![index])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 새로운 사진을 저장한다.
    // create by EZDev on 2020.03.27
    func addNewPicture(memo: Memo, pic: Picture) {
        do {
            try realm?.write{
                memo.imageArray.append(pic)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 사진을 삭제한다.
    // create by EZDev on 2020.03.27
    func deletePicture(memo: Memo, index: Int) {
        do {
            try realm?.write {
                realm?.delete(memo.imageArray[index])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
