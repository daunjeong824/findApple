//
//  UICollectionViewCell.swift
//  FindApple
//
//  Created by 정다운 on 2022/05/21.
//

import UIKit

// Custom Cell Class
class Cell: UICollectionViewCell {
    static let identifier = "Cell"
    
    var imgview: UIImageView = {
        let imgview = UIImageView(frame: CGRect(x: 0, y: 0, width: 150.0, height: 150.0))
        imgview.backgroundColor = .darkGray
        return imgview
    }()
    
    // 사과를 위한 더 작은 UIIMageView 를 만듦
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialize code
    }
    
    func updateImage(_ img: UIImage?, isVisible: Bool?) { // isHidden 이나 별도의 enum을 선언해서쓰자
        self.contentView.addSubview(self.imgview)
        if let status = isVisible,
           status {
            self.imgview.image = img
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgview.image = nil
        self.imgview.backgroundColor = .darkGray
    }
}
