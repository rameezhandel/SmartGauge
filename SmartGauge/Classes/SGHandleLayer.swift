//
//  SGHandleLayer.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import QuartzCore
import UIKit

class SGHandleLayer: SGBaseLayer {
    
    //MARK: Private properties
    private var circleLayer: CAShapeLayer?
    private var arrowLayer: CAShapeLayer?
    private var innerCircleLayer: CAShapeLayer?

    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupHandle()
        setupRotation()
    }
    
    private func setupRotation() {
        guard let value = gaugeValue else { return }
        let convertedVal = angleForValue(value)
        let angle = CGFloat(convertedVal).deg2rad() + CGFloat(gaugeAngle).deg2rad() - CGFloat.pi
        let transform = CGAffineTransform(rotationAngle: angle)
        arrowLayer?.setAffineTransform(transform)
    }

    
    private func setupHandle() {
        circleLayer?.removeFromSuperlayer()
        arrowLayer?.removeFromSuperlayer()
        innerCircleLayer?.removeFromSuperlayer()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)

        circleLayer = createCircleLayer(radius/10.0, color: UIColor.lightGray.withAlphaComponent(0.2))
        addSublayer(circleLayer!)
        
        var trackColor = UIColor.blue
        for range in rangesList {
            if (gaugeValue ?? 0.0) <= range.toValue {
                trackColor = range.color ?? UIColor.blue
                break
            }
        }

        arrowLayer = CAShapeLayer()
        arrowLayer?.strokeColor = trackColor.cgColor
        arrowLayer?.fillColor = trackColor.cgColor
        arrowLayer?.lineCap = .round
        
        let path = CGMutablePath()
        let leftCenter = CGPoint(x: center.x - radius/18.0, y: center.y)
        path.move(to: leftCenter)
        path.addArc(center: center, radius: radius/18.0, startAngle: 0, endAngle: .pi, clockwise: false)

        path.addLine(to: CGPoint(x: radius, y: radius/2.5))
        let rightCenter = CGPoint(x: center.x + radius/18.0, y: center.y)
        path.addLine(to: rightCenter)
        arrowLayer?.path = path
        arrowLayer?.frame = bounds
        addSublayer(arrowLayer!)
        
        innerCircleLayer = createCircleLayer(radius/30.0, color: UIColor.white)
        addSublayer(innerCircleLayer!)
    }
    
    private func createCircleLayer(_ radius: CGFloat, color: UIColor) -> CAShapeLayer? {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circleRadius = radius
        let circleLayer = CAShapeLayer()
        circleLayer.strokeColor = color.cgColor
        circleLayer.fillColor = color.cgColor
        let circlePath = CGMutablePath()
        let circleRect = CGRect(x: center.x-circleRadius, y: center.y-circleRadius, width: circleRadius*2.0, height: circleRadius*2.0)
        circlePath.addRoundedRect(in: circleRect, cornerWidth: circleRadius, cornerHeight: circleRadius)
        circleLayer.frame = bounds
        circleLayer.path = circlePath
        return circleLayer
    }
}
