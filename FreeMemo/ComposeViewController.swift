//
//  ComposeViewController.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/07.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit
import Photos

class ComposeViewController: UIViewController {
    
    var isKeyboard: Bool = true
    let picker: UIImagePickerController = UIImagePickerController()
    var addImages: [UIImage] = []
    var addName: [String?] = []
    
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
        let btn: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "hide_keyboard"), style: .plain, target: self, action: #selector(keyboard(_:)))
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 초기에 제목을 입력하수 있게 바로 키보드를 올린다.
        // create by EZDev on 2020.03.08
        titleTextField.becomeFirstResponder()
        
        // 키보드의 높이를 가져올수 있게 하는 노티를 등록한다
        // create by EZDev on 2020.03.08
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        view.endEditing(true)
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
    
    
    // 기존 화면으로 되돌아가기
    // create by EZDev on 2020.03.07
    @objc func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save(_ sender: Any) {
        // core data에 저장하는 코드 구현 예정
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
    
    @objc func showKeyboard(_ noti: Notification) {
        // 키보드의 크기를 가져와서 테이블뷰의 높이를 설정해준다.
        // create by EZDev on 2020.03.08
        if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
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
    }
}


// 추가된 이미지가 보여지는 테이블뷰의 데이터, 델리게이트 정의
// create by EZDev on 2020.03.08
extension ComposeViewController: UITableViewDataSource, UITableViewDelegate {
    // 테이블에 표현할 셀의 갯수
    // create by EZDev on 2020.03.08
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addImages.count
    }
    
    // 셀에 보여질 아이템 업데이트
    // create by EZDev on 2020.03.08
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! PictureCell
        
        cell.thumbnail.image = addImages[indexPath.row]
        cell.imageName.text = addName[indexPath.row]
        
        return cell
    }
    
    // 추가된 이미지셀을 삭제
    // create by EZDev on 2020.03.08
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "삭제") { (action, indexPath) in
            self.addImages.remove(at: indexPath.row)
            self.addName.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.addName)
        }
        return [delete]
    }

}

// 앨범, 카메라 접근 컨트롤
// create by EZDev on 2020.03.08
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 앨범 접근후 화면에 보여주기
    // create by EZDev on 2020.03.08
    func openAlbum() {
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    // 카메라 접근후 화면에 보여주기
    // creat by EZDev on 2020.03.08
    func openCam() {
        picker.sourceType = .camera
        
        present(picker, animated: true, completion: nil)
    }
    
    // 앨범에서 선택한 이미지와 이미지 이름을 배열에 저장한다.
    // creat by EZDev on 2020.03.08
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImages.append(image)
        }
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            guard let firstObj = asset.firstObject else { return }
            let fileName = PHAssetResource.assetResources(for: firstObj).first?.originalFilename
            
            addName.append(fileName)
        }
        else {
            // 카메라 접근시 날짜로 이름을 설정후 배열에 저장한다.
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            addName.append(dateFormatter.string(from: date))
        }
        
        imageTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
    }
}
