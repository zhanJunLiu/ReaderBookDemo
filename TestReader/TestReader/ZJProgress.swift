//
//  ZJProgress.swift
//  CHReadingBook
//
//  Created by macbook on 2016/11/14.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class ZJProgress: UIButton {
    // 创建一个提供外部可以调用的接口
    var process: Float? {
        didSet{
            self.setTitle("\(process!*100)", forState: .Normal)
            self.setTitleColor(UIColor.blackColor(), forState: .Normal)
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        guard let process = process else{
            return
        }
        
        let center:CGPoint = CGPointMake(rect.size.width * 0.5, rect.size.height*0.5)
        let radius:CGFloat  = CGFloat(40)
        let starAngle:CGFloat = CGFloat(-M_PI_2)
        let endAngle:CGFloat = CGFloat(process) * CGFloat(2) * CGFloat(M_PI) + starAngle
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: starAngle, endAngle: endAngle, clockwise: true)
        
        // 饼图部分
//        path.addLineToPoint(center)  //从上一点连接一条线到本次指定的点
//        UIColor.redColor().setFill()
//        path.fill()
        
        // 划线部分
        path.lineWidth = 5
        path.lineCapStyle = .Round
        UIColor.redColor().setStroke()
        path.stroke()
    }
}
