//
//  AddPictureController.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/27.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit
import Photos

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
        
        var imageName: String
        var imageData: Data?
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Realm에 저장하기위한 image jpeg 데이터로 변환
            // create by EZDev on 2020.03.23
            imageData = image.jpegData(compressionQuality: 0.1)
        }
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            guard let firstObj = asset.firstObject else { return }
            guard let fileName = PHAssetResource.assetResources(for: firstObj).first?.originalFilename else { return }
            imageName = fileName
        }
        else {
            // 카메라 접근시 날짜로 이름을 설정후 배열에 저장한다.
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            imageName = dateFormatter.string(from: date)
        }
        
        // 새로운 객체를 만든다.
        // create by EZDev on 2020.03.23
        let picture = Picture()
        picture.imageData = imageData!
        picture.name = imageName
        if let sendMemo = memo {
            DataMgr.shared.addNewPicture(memo: sendMemo, pic: picture)
        }
        imageTableView.reloadData()
        
        
        dismiss(animated: true, completion: nil)
    }
}
