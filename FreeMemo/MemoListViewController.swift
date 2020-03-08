//
//  MemoListViewController.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/05.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

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
        
        // 테스트를 위한 데이터 삽입
        // create by EZDev on 2020.03.06
        img.append(UIImage(named: "notebook"))
        titleName.append("this is image")
        content.append("this is image content this is image content this is image content this is image content this is image content this is image content this is image content this is image content ")
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // memotableview 데이터, 셀, 델리게이트 등록
        // create by EZDev on 2020.03.07
        memoTableView.dataSource = self
        memoTableView.register(ImageCell.self, forCellReuseIdentifier: "imageCell")
        memoTableView.register(LabelCell.self, forCellReuseIdentifier: "labelCell")
        memoTableView.delegate = self

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

}

// 액션에 관한 모든 것을 관리 합니다.
// create by EZDev on 2020.03.05
extension MemoListViewController {
    @objc func addMemo(_ sender: UIBarButtonItem) {
        // 새로운 메모화면으로 넘어갈때 네비게이션을 감싸서 넘겨준다.
        // create by on EZDev on 2020.03.07
        let compose = UINavigationController(rootViewController: ComposeViewController())
        compose.view.backgroundColor = .white
        compose.navigationBar.tintColor = .systemOrange        
        
        present(compose, animated: true, completion: nil)
    }
}

// tableview에 필요한 데이터, 델리게이트 구현
// create by EZDev on 2020.03.07
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 이미지가 포함된 셀 혹은 텍스트로만 이루어진 셀의 분기를 나누는 테스트 코드
        // create by EZDev on 2020.03.06
        if img.count > indexPath.row, let image = img[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell

            cell.thumbnaile.image = image
            cell.titleLabel.text = titleName[indexPath.row]
            cell.contentLabel.text = content[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath) as! LabelCell

            cell.titleLabel.text = titleName[indexPath.row]
            cell.contentLabel.text = content[indexPath.row]

            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("click cell")
    }
    
    
}

