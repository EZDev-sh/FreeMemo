//
//  ComposeViewController.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/07.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit


class ComposeViewController: UIViewController {
    
    // 키보드 사용중인지 아닌지 확인 하는 아이템
    // create by EZDev on 2020.03.11
    var isKeyboard: Bool = true
    // 추가되는 이미지를 컨트롤 하는 아이템
    // create by EZDev on 2020.03.11
    let picker: UIImagePickerController = UIImagePickerController()
    
    var editMemo: Memo?
    var memo: Memo?
    var newMemoMode: Bool = false
    
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
        textView.textColor = .black
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
        let btn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "hide_keyboard"), style: .plain, target: self, action: #selector(keyboard(_:)))
        
        return btn
    }()
    
    
    
    override func loadView() {
        super.loadView()
        
        // ViewController에 기본 환경을 설정해준다.
        // create by EZDev on 2020.03.12
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemOrange
        
        // 화면에 컴포넌트 추가
        // create by EZDev on 2020.03.07
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(editToolBar)
        view.addSubview(imageTableView)
        
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = saveBtn
        
        // 툴바 설정
        // create by EZDev on 2020.03.07
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        editToolBar.setItems([pictureBtn, space, keyboardBtn], animated: true)
        
        initConstraint()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 초기에 제목을 입력하수 있게 바로 키보드를 올린다.
        // create by EZDev on 2020.03.08
        contentTextView.becomeFirstResponder()
        
        // 키보드의 높이를 가져올수 있게 하는 노티를 등록한다
        // create by EZDev on 2020.03.08
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        view.endEditing(true)
        
        // 새로운 매모작성인지 수정인지 확인
        // create by EZDev on 2020.03.23
        if let tempMemo = editMemo {
            navigationItem.title = "메모 수정"
            titleTextField.text = tempMemo.title
            contentTextView.text = tempMemo.content
            imageTableView.reloadData()
            
            memo = tempMemo
        } else {
            memo = Memo()
            newMemoMode = true
            navigationItem.title = "새로운 메모"
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // textview 델리게이트, tableview datasource, delegat, cell 등록
        // create by EZDev on 2020.03.08
        contentTextView.delegate = self
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.register(PictureCell.self, forCellReuseIdentifier: "pictureCell")
        picker.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 화면이 사라질때 composeview에서 등록했던 모든 노티를 제거한다.
        // create by EZDev on 2020.03.08
        NotificationCenter.default.removeObserver(self)
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
            titleTextField.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16),
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
  
        ])
    }

    
    // 키보드의 크기를 가져와서 테이블뷰의 높이를 설정해준다.
    // create by EZDev on 2020.03.27
    @objc func showKeyboard(_ noti: Notification) {
        if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var height = frame.cgRectValue.height
            if #available(iOS 11.0, *) {
                // 모든 뷰가 safearea영역이 있을경우의 높이 조정
                // create by EZDev on 2020.03.27
                height -= self.view.safeAreaInsets.bottom
            }
            imageTableView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    // 이미지 추가방식의 액션시트를 정의 합니다.
    // create by EZDev on 2020.03.08
    func showAlert() {
        let alert = UIAlertController(title: "이미지 추가방식을 선책해주세요.", message: .none, preferredStyle: .actionSheet)
        let cam = UIAlertAction(title: "카메라", style: .default) { (action) in
            // 카메라에 접근
            self.openCam()
        }
        let album = UIAlertAction(title: "앨범", style: .default) { (action) in
            // 앨범에 접근
            self.openAlbum()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        
        alert.addAction(cam)
        alert.addAction(album)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

// textview에 placeholde 기능을 구현
// create by EZDev on 2020.03.05
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
        else {
            contentTextView.textColor = .black
        }
    }
}

// 추가된 이미지가 보여지는 테이블뷰의 데이터, 델리게이트 정의
// create by EZDev on 2020.03.08
extension ComposeViewController: UITableViewDataSource, UITableViewDelegate {
    // 테이블에 표현할 셀의 갯수
    // create by EZDev on 2020.03.08
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (memo?.imageArray.count) ?? 0
    }
    
    // 셀에 보여질 아이템 업데이트
    // create by EZDev on 2020.03.08
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! PictureCell
        
        let picture = memo?.imageArray[indexPath.row]
        cell.thumbnail.image = UIImage(data: picture!.imageData)
        cell.imageName.text = picture?.name
        
        return cell
    }
    
    // db에 추가했던 이미지 셀 삭제
    // create by EZDev on 2020.03.23
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in

            if let sendMemo = self.memo {
                DataMgr.shared.deletePicture(memo: sendMemo, index: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        return [delete]
    }

}

// MemoListViewController에서 받을 노티피케이션 이름을 정의
// click 액션에대한 정의
// create by EZDev on 2020.03.11
extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    
    // 기존 화면으로 되돌아가기
    // create by EZDev on 2020.03.07
    @objc func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 작성한 메모를 Realm에 저장한다.
    // create by EZDev on 2020.03.25
    @objc func save(_ sender: Any) {
        if newMemoMode {
            memo?.title = titleTextField.text!
            memo?.content = contentTextView.text
            
            if let sendMemo = memo {
                DataMgr.shared.addNewMemo(memo: sendMemo)
            }
        }
        else {
            if let sendMemo = editMemo {
                DataMgr.shared.modifyMemo(memo: sendMemo, title: titleTextField.text!, content: contentTextView.text)
            }
        }
        
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    // 사진을 추가하는 방식의 액션시트를 보여줍니다.
    // create by EZDev on 2020.03.08
    @objc func picture(_ sender: Any) {
        if isKeyboard {
            isKeyboard = false
            view.endEditing(true)
            keyboardBtn.image = UIImage(named: "show_keyboard")
        }
        showAlert()
    }
    
    // 키보드 버튼이 눌렸을때 키보드 on/off 기능
    // create by EZDev on 2020.03.08
    @objc func keyboard(_ sender: UIBarButtonItem) {
        if isKeyboard {
            isKeyboard = false
            self.view.endEditing(true)
            sender.image = UIImage(named: "show_keyboard")
        }
        else {
            isKeyboard = true
            contentTextView.becomeFirstResponder()
            sender.image = UIImage(named: "hide_keyboard")
        }
    }
}
