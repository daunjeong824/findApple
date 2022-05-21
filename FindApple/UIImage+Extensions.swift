//
//  UIImage+Extensions.swift
//  FindApple
//
//  Created by 정다운 on 2022/05/20.
//

import UIKit

// UIImage Custom Func
extension UIImage {
    func imageResize(to size: CGSize) -> UIImage {
        let img =  UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return img.withRenderingMode(renderingMode)
    }
}

extension UIImage {
    static let backGround = UIImage(named: "backGround")!
    static let apple = UIImage(named: "Apple")!
}
