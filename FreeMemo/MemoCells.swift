//
//  MemoCells.swift
//  FreeMemo
//
//  Created by EZDev on 2020/03/05.
//  Copyright © 2020 EZDev. All rights reserved.
//

import UIKit


// 이미지가 저장되어있는 메모인경우 보여지는 셀
// create by EZDev on 2020.03.05
class ImageCell: UITableViewCell {
    
    // 이미지가 포함된 셀에 포함되어야 할 컴포넌트 정의
    // create by EZDev on 2020.03.06
    lazy var thumbnaile: UIImageView = {
        let img: UIImageView = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var titleLabel: UILabel = {
        let title: UILabel = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return title
    }()
    
    lazy var contentLabel: UILabel = {
        let content: UILabel = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont.systemFont(ofSize: 20)
        content.textColor = .lightGray
        content.numberOfLines = 2
        return content
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 셀선택 효과 없애기
        // create by EZDev on 2020.03.07
        self.selectionStyle = .none
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        // 셀에 컴포넌트 추가
        // create by EZDev on 2020.03.06
        self.addSubview(self.thumbnaile)
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        
        // 각 컴포넌트의 제약사항 추가
        // create by EZDev on 2020.03.06
        NSLayoutConstraint.activate([
            self.thumbnaile.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.thumbnaile.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.thumbnaile.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.thumbnaile.widthAnchor.constraint(equalToConstant: 100),
            self.thumbnaile.heightAnchor.constraint(equalToConstant: 100),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.thumbnaile.rightAnchor, constant: 8),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            
            self.contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            self.contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            self.contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
            
            
            
        ])
        
    }
}

// 이미지 없이 글만 저장되어있는 메모인경우 보여지는 셀
// create by EZDev on 2020.03.05
class LabelCell: UITableViewCell {
    // 텍스트로 이루어진 셀에 포함되어야 할 컴포넌트 정의
    // create by EZDev on 2020.03.06
    lazy var titleLabel: UILabel = {
        let title: UILabel = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return title
    }()
    
    lazy var contentLabel: UILabel = {
        let content: UILabel = UILabel()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.font = UIFont.systemFont(ofSize: 20)
        content.textColor = .lightGray
        content.numberOfLines = 2
        return content
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 셀선택 효과 없애기
        // create by EZDev on 2020.03.07
        self.selectionStyle = .none
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        // 셀에 컴포넌트 추가
        // create by EZDev on 2020.03.06
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        
        // 각 컴포넌트의 제약사항 추가
        // create by EZDev on 2020.03.06
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            
            self.contentLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor)
            
        ])
    }
}
