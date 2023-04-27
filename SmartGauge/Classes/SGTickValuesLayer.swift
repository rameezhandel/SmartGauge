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
    
    var coveredTickValueColor: UIColor = UIColor.black {
        didSet { updateUI() }
    }

    var uncoveredTickValueColor: UIColor = UIColor.lightGray {
        didSet { updateUI() }
    }

    var tickValueFontSize: CGFloat? {
        didSet { updateUI() }
    }

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
        
        guard numberOfMajorTicks > 0 else { return }
        let maxRangeValue = gaugeValue ?? 0.0 > gaugeMaxValue ? gaugeValue ?? 0.0 : gaugeMaxValue
        let devider = maxRangeValue / CGFloat(numberOfMajorTicks)
        guard devider > 0 else { return }
        let labelsCount = Int(maxRangeValue/devider)

        for index in 0..<(labelsCount+1) {
            
            let floatValue = (maxRangeValue*CGFloat(index)/CGFloat(labelsCount)).rounded(2)
            var displayValue = "\(floatValue)"
            
            if floor(floatValue) == floatValue {
                displayValue = "\(Int(floatValue))"
            }

            let layer = CATextLayer()
            layer.font = CTFontCreateUIFontForLanguage(.system, radius/30.0, nil)
            layer.fontSize = tickValueFontSize ?? radius/10.0
            layer.contentsScale = contentsScale
            layer.foregroundColor = (gaugeValue ?? 0) >= CGFloat(floatValue) ? coveredTickValueColor.cgColor : uncoveredTickValueColor.cgColor
            layer.frame = bounds.insetBy(dx: +radius/3.5, dy: +radius/3.5)
            layer.string = displayValue
            layer.alignmentMode = CATextLayerAlignmentMode.center

            let convertedValue = angleForValue(CGFloat(floatValue))

            let degress = convertedValue + gaugeAngle + 180.0
            let radians = CGFloat(degress).deg2rad()
            
            let transform = CGAffineTransform(rotationAngle: CGFloat(radians))
            layer.setAffineTransform(transform)
            
            addSublayer(layer)
            rangesLayers?.append(layer)
        }
        
        /*
        let maxRangeValue = Int(gaugeMaxValue)
        let devider = maxRangeValue / numberOfMajorTicks
        let labelsCount = maxRangeValue/devider
        
        for index in 0..<(labelsCount+1) {
            let value = (maxRangeValue*index)/labelsCount
            
            let layer = CATextLayer()
            layer.font = CTFontCreateUIFontForLanguage(.system, radius/30.0, nil)
            layer.fontSize = radius/10.0
            layer.contentsScale = contentsScale
            layer.foregroundColor = (gaugeValue ?? 0) >= CGFloat(value) ? coveredTickValueColor.cgColor : uncoveredTickValueColor.cgColor
            layer.frame = bounds.insetBy(dx: +radius/3.5, dy: +radius/3.5)
            layer.string = "\(value)"
            layer.alignmentMode = CATextLayerAlignmentMode.center

            let convertedValue = angleForValue(CGFloat(value))

            let degress = convertedValue + gaugeAngle + 180.0
            let radians = CGFloat(degress).deg2rad()
            
            let transform = CGAffineTransform(rotationAngle: CGFloat(radians))
            layer.setAffineTransform(transform)
            
            addSublayer(layer)
            rangesLayers?.append(layer)
        }
 */
    }
}
