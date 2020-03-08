//
//  PictureCell.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/08.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit

class PictureCell: UITableViewCell {
    
    // cell에 포함되는 컴포넌트 정의
    // create by EZDev on 2020.03.08
    lazy var thumbnail: UIImageView = {
        let imgView: UIImageView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var imageName: UILabel = {
        let name: UILabel = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 셀선택 효과 없애기
        // create by EZDev on 2020.03.08
        self.selectionStyle = .none
        
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        
        // cell에 컴포넌트 추가
        // creat by EZDev on 2020.03.08
        addSubview(thumbnail)
        addSubview(imageName)
        
        // 각 컴포넌트의 제약조건 추가
        // create by EZDev on 2020.03.05
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            thumbnail.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            thumbnail.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            thumbnail.widthAnchor.constraint(equalToConstant: 80),
            thumbnail.heightAnchor.constraint(equalToConstant: 80),
            
            imageName.topAnchor.constraint(equalTo: thumbnail.topAnchor),
            imageName.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor),
            imageName.leftAnchor.constraint(equalTo: thumbnail.rightAnchor, constant: 8),
            imageName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)

        ])
    }
    
    
    
}
