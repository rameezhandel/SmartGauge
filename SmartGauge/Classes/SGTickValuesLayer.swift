//
//  SGTickValuesLayer.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import QuartzCore
import UIKit

class SGTickValuesLayer: SGBaseLayer {
    
    private var rangesLayers: [CALayer]?

    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupTickValues()
    }
    
    private func setupTickValues() {
        if let rangeLayers = rangesLayers {
            for rangeLayer in rangeLayers {
                rangeLayer.removeFromSuperlayer()
            }
        }
        
        let radius = min(bounds.midX, bounds.midY) - 8.0

        rangesLayers = [CALayer]()
        
        
        let maxRangeValue = Int(gaugeMaxValue)
        let devider = maxRangeValue / numberOfMajorTicks
        let labelsCount = maxRangeValue/devider
        
        for index in 0..<(labelsCount+1) {
            let value = (maxRangeValue*index)/labelsCount
            
            let layer = CATextLayer()
            layer.font = CTFontCreateUIFontForLanguage(.system, radius/30.0, nil)
            layer.fontSize = radius/10.0
            layer.contentsScale = contentsScale
            layer.foregroundColor = (gaugeValue ?? 0) > CGFloat(value) ? UIColor.black.cgColor : UIColor.lightGray.cgColor
            layer.frame = bounds.insetBy(dx: +radius/3.5, dy: +radius/3.5)
            layer.string = "\(value)" // \(Int(CGFloat(value) / gaugeValuesScale + gaugeValuesOffset))"
            layer.alignmentMode = CATextLayerAlignmentMode.center

            let convertedValue = angleForValue(CGFloat(value))

            let degress = convertedValue + gaugeAngle + 180.0
            let radians = CGFloat(degress).deg2rad()
            
            let transform = CGAffineTransform(rotationAngle: CGFloat(radians))
            layer.setAffineTransform(transform)
            
            addSublayer(layer)
            rangesLayers?.append(layer)
        }
    }
}
