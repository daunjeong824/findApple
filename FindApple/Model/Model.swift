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
    let apple: UIImage = .apple
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
                
                var tmp: CGImage = image.cgImage!.cropping(to: tie)! // 타일만큼 원본 이미지에서 떼기
                imgSet.append(UIImage(cgImage: tmp))
            }
        }
        let newImgSet = self.makeApple(imgSet: imgSet)
        self.delegate?.modelDidFinishDividingImages(imgSet: newImgSet)
    }
    
    // make Apple () -> self.delegate?..
    func makeApple(imgSet: [UIImage]) -> [UIImage]{
        var newImgSet = imgSet
        var newImage = UIImage()
        
        // 1. random으로 imgSet 중 하나를 고르기 & 그 Index도 얻기
        guard let randomImage: UIImage = newImgSet.randomElement(),
              let randomIndex: Int = (newImgSet.firstIndex { $0 === randomImage }) else { return imgSet}
        
        // 2. 그 요소에 사과 모양 이미지를 랜덤으로 배치
        newImage = putImageToAnotherImage(backGround: randomImage, toPutImage: apple, position: CGPoint(x: randomImage.size.width / 2.0 , y: randomImage.size.height / 2.0))
        // 3. myImgSet에 반영
        newImgSet[randomIndex] = newImage
        return newImgSet
    }
    
    func putImageToAnotherImage(backGround: UIImage, toPutImage: UIImage, position: CGPoint) -> UIImage {
        //CG 지원 이미지 만들기 위한 Graphic Renderer 생성
        let renderer = UIGraphicsImageRenderer(size: backGround.size)
        // renderer에 image 생성해 반환(UIImage)
        return renderer.image { ctx in
            backGround.draw(in: CGRect(origin: CGPoint.zero, size: backGround.size))
            toPutImage.draw(in: CGRect(origin: position, size: toPutImage.size))
        }
    }
}
