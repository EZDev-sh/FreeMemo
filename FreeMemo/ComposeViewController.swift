//
//  ComposeViewController.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/07.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // 네비게이션바에 필요한 버튼 정의
    // create by EZDev on 2020.03.07
    lazy var cancelBtn: UIBarButtonItem = {
        let btn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(_:)))
        
        return btn
    }()
    
    lazy var saveBtn: UIBarButtonItem = {
        let btn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save(_:)))
        
        return btn
    }()
    
    // composeview에 보여질 컴포넌트 정의
    // create EZDev on 2020.03.07
    lazy var titleTextField: UITextField = {
        let title: UITextField = UITextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 28)
        title.placeholder = "제목"
        
        return title
    }()
    
    lazy var contentTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.text = "메모"
        textView.textColor = .lightGray
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    lazy var imageTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // toolbar, 사진 불러오기, 키보드 on/off 정의
    // create by EZDev on 2020.03.07
    lazy var editToolBar: UIToolbar = {
        let toolbar: UIToolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.tintColor = .systemOrange
        toolbar.semanticContentAttribute = .unspecified
        toolbar.contentMode = .scaleToFill
        
        return toolbar
    }()
    
    lazy var pictureBtn: UIBarButtonItem = {
        let btn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "photo"), style: .plain, target: self, action: #selector(picture(_:)))
        
        return btn
    }()
    
    lazy var keyboardBtn: UIBarButtonItem = {
        let btn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "show_keyboard"), style: .plain, target: self, action: #selector(keyboard(_:)))
        
        return btn
    }()
    
    override func loadView() {
        super.loadView()
        
        // 화면에 컴포넌트 추가
        // create by EZDev on 2020.03.07
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(editToolBar)
        view.addSubview(imageTableView)
        
        // 네비게이션바 설정
        // create by EZDev on 2020.03.07
        navigationItem.title = "새로운 메모"
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = saveBtn
        
        // 툴바 설정
        // create by EZDev on 2020.03.07
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        editToolBar.setItems([pictureBtn, space, keyboardBtn], animated: true)
        
        initConstraint()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // textview 델리게이트, tableview datasource 등록
        // create by EZDev on 2020.03.07
        contentTextView.delegate = self
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.register(PictureCell.self, forCellReuseIdentifier: "pictureCell")
    }
    
    func initConstraint() {
        // iOS 버전에 따른 분기 설정
        // create by EZDev on 2020.03.07
        var guide: UILayoutGuide
        if #available(iOS 11.0, *) {
            guide = view.safeAreaLayoutGuide
        } else {
            guide = view.readableContentGuide
        }
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            titleTextField.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 20),
            titleTextField.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -8),
            
            contentTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            
            editToolBar.topAnchor.constraint(equalTo: contentTextView.bottomAnchor),
            editToolBar.leftAnchor.constraint(equalTo: guide.leftAnchor),
            editToolBar.rightAnchor.constraint(equalTo: guide.rightAnchor),
            
            imageTableView.topAnchor.constraint(equalTo: editToolBar.bottomAnchor),
            imageTableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            imageTableView.leadingAnchor.constraint(equalTo: editToolBar.leadingAnchor),
            imageTableView.trailingAnchor.constraint(equalTo: editToolBar.trailingAnchor),
            imageTableView.heightAnchor.constraint(equalToConstant: 200)
            
            
        ])
    }
    
    
    // 기존 화면으로 되돌아가기
    // create by EZDev on 2020.03.07
    @objc func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save(_ sender: Any) {
        // core data에 저장하는 코드 구현 예정
    }
    
    @objc func picture(_ sender: Any) {
        // 사진 추가되는거 구현 예정
    }
    
    @objc func keyboard(_ sender: Any) {
        // 키보드 컨트롤 구현 예정
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ComposeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        initTextview()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text == "" {
            initTextview()
        }
    }
    func initTextview() {
        if contentTextView.text == "메모" {
            contentTextView.text = ""
            contentTextView.textColor = .black
        }
        else if contentTextView.text == "" {
            contentTextView.text = "메모"
            contentTextView.textColor = .lightGray
        }
    }
}

extension ComposeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! PictureCell
        
        cell.thumbnail.image = UIImage(named: "Splash_image")
        cell.imageName.text = "EZDeveloper"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            print(indexPath.row)
        }
        
        return [delete]
    }
    
    
}
