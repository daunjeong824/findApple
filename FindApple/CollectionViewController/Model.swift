//
//  Model.swift
//  FindApple
//
//  Created by 정다운 on 2022/05/20.
//

import UIKit

// Model protocol: Model Delegate
protocol ModelDelegate: NSObject {
    func modelDidFinishDividingImages(imgSet: [UIImage]?)
}

// MARK: Model
class Model {
    var myImg: UIImage
    var imgSet: [UIImage] = [UIImage]()
    weak var delegate: ModelDelegate?
    
    init(myImg: UIImage) {
        self.myImg = myImg
    }

    // 1. img를 받아서, tieSize 크기만큼 분할하여 배열로 저장하는 함수
    func divImg(tileSize: Int) {
        let image: UIImage = self.myImg.imageResize(to: CGSize(width: 450, height: 450))
        let wCount = Int(image.size.width) / tileSize
        let hCount = Int(image.size.height) / tileSize
        let scale = (image.scale)
        var imgSet: [UIImage] = []
        
        for h in 0...hCount-1 {
            for w in 0...wCount-1 {
                let tie = CGRect(x: CGFloat(CGFloat(w*tileSize)*scale), y: CGFloat(CGFloat(h*tileSize)*scale), width: CGFloat(CGFloat(tileSize)*scale), height: CGFloat(CGFloat(tileSize)*scale)) // 타일 setting (좌표&크기)
                let tmp: CGImage = image.cgImage!.cropping(to: tie)! // 타일만큼 원본 이미지에서 떼기
                imgSet.append(UIImage(cgImage: tmp))
            }
        }
        
        self.delegate?.modelDidFinishDividingImages(imgSet: imgSet)
    }
}
