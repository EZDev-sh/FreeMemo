//
//  MemoListViewController.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/05.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
    
    // 필요한 컴포넌트 정의
    // create by EZDev on 2020.03.05
    lazy var addMemo: UIBarButtonItem = {
        let btn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMemo(_:)))
        
        return btn
    }()
    
    lazy var memoTableView: UITableView = {
        let table: UITableView = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 120
        
        return table
    }()
    
    var img: [UIImage?] = []
    var titleName: [String] = []
    var content: [String] = []
    
    var memoArray: Results<Memo>?
    var realm: Realm?
    
    
    
    // 화면에 보여질 컴포넌트들 추가
    // create by EZDev on 2020.03.05
    override func loadView() {
        super.loadView()
        self.navigationItem.title = "모든메모"
        self.navigationItem.rightBarButtonItem = addMemo
        
        view.addSubview(memoTableView)
        
        initConstraint()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            realm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
        print(NSHomeDirectory())
        loadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // memotableview 데이터, 셀, 델리게이트 등록
        // create by EZDev on 2020.03.07
        memoTableView.dataSource = self
        memoTableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        memoTableView.register(LabelCell.self, forCellReuseIdentifier: "labelCell")
        memoTableView.delegate = self
        
        // 싱글톤에 저장된 내용을 보기위한 노티 등록 및 테이블뷰 업데이트
        // create by EZDev on 2020.03.11
        NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.memoTableView.reloadData()
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // MemoListViewController에 등록된 노티피케이션 모두 삭제
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // 오토레이아웃 정의
    // create by EZDev on 2020.03.05
    func initConstraint() {
        
        // iOS 버전에 따른 분기 설정
        // create by EZDev on 2020.03.05
        var guide: UILayoutGuide
        if #available(iOS 11.0, *) {
            guide = view.safeAreaLayoutGuide
        } else {
            guide = view.readableContentGuide
        }
        
        NSLayoutConstraint.activate([
            memoTableView.topAnchor.constraint(equalTo: guide.topAnchor)
            , memoTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
            , memoTableView.leftAnchor.constraint(equalTo: guide.leftAnchor)
            , memoTableView.rightAnchor.constraint(equalTo: guide.rightAnchor)
        ])
        
    }
    
    func loadData() {
        memoArray = realm?.objects(Memo.self)
        memoTableView.reloadData()
    }
    
}

// 액션에 관한 모든 것을 관리 합니다.
// create by EZDev on 2020.03.05
extension MemoListViewController {
    @objc func addMemo(_ sender: UIBarButtonItem) {
        // 새로운 메모화면으로 넘어갈때 네비게이션을 감싸서 넘겨준다.
        // create by on EZDev on 2020.03.07
        let compose = UINavigationController(rootViewController: ComposeViewController())
        
        present(compose, animated: true, completion: nil)
    }
}

// tableview에 필요한 데이터, 델리게이트 구현
// create by EZDev on 2020.03.07
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray?.count ?? 0
        //        return DataMgr.shared.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let memo = memoArray?[indexPath.row]
        
        if memo?.imageArray.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
            
            cell.thumbnaile.image = UIImage(data: (memo?.imageArray[0].imageData)!)
            cell.titleLabel.text = memo?.title
            cell.contentLabel.text = memo?.content
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelCell
            cell.titleLabel.text = memo?.title
            cell.contentLabel.text = memo?.content
            return cell
        }
        
    }
    
    // 선택한 셀의 정보를 ComposeViewController 로 보내 수정 가능한 환경으로 변경해준다.
    // create by EZDev on 2020.03.12
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let compose = ComposeViewController()
        guard let memo = memoArray?[indexPath.row] else { return }
        
        compose.editMemo = memo
        
        
        present(UINavigationController(rootViewController: compose), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            
            do {
                try self.realm?.write {
                    self.realm?.delete(self.memoArray![indexPath.row])
                }
            } catch {
                print(error.localizedDescription)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        return [delete]
    }
    
    
}

