//
//  SGTickLayer.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import QuartzCore
import UIKit

class SGTickLayer: SGBaseLayer {
        
    //MARK: Public Properties
    var numberOfMinorTicks: Int = 3 {
        didSet { updateUI() }
    }

    public var tickColor: UIColor = UIColor.lightGray {
        didSet { updateUI() }
    }

    //MARK: Private Properties
    private var tickRangesLayers: [CALayer]?

    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupTickLayer()
    }
    
    private func setupTickLayer() {
        if let tickRangesLayers = tickRangesLayers {
            for tickRangesLayer in tickRangesLayers {
                tickRangesLayer.removeFromSuperlayer()
            }
        }
        
        tickRangesLayers = []
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)
        

        let trackMaxValue = gaugeValue ?? 0.0 > gaugeMaxValue ? gaugeValue ?? 0.0 : gaugeMaxValue
        let divider = trackMaxValue / CGFloat(numberOfMajorTicks)
        var majorTickValuesArray: [Int] = []

        for tickNumber in 0...numberOfMajorTicks {
            let val = CGFloat(tickNumber) * divider
            let finalTickVal = angleForValue(CGFloat(val))
            majorTickValuesArray.append(Int(finalTickVal))
        }
        
        // Calculate minor ticks
        let totalNumberOfMinorTicks = (majorTickValuesArray.count - 1) * (numberOfMinorTicks + 1)
        let minorDivider = trackMaxValue / CGFloat(totalNumberOfMinorTicks)
        var minorTickValuesArray: [CGFloat] = []
        
        for tickNumber in 0...totalNumberOfMinorTicks {
            let val = CGFloat(tickNumber) * minorDivider
            let finalTickVal = angleForValue(CGFloat(val))
            minorTickValuesArray.append(finalTickVal)
        }

        let tickScalesPath = CGMutablePath()

        for tickValue in majorTickValuesArray {
            let linePath = CGMutablePath()

            linePath.move(to: CGPoint(x: radius - radius/4.0, y: 0.0))

            linePath.addLine(to: CGPoint(x: radius - radius/4.0 + radius/15.0, y: 0.0))

            let transform = CGAffineTransform(rotationAngle: (CGFloat(tickValue) + 90.0 + gaugeAngle).deg2rad())
            tickScalesPath.addPath(linePath, transform: transform)
        }
        
        for tickValue in minorTickValuesArray {
            let linePath = CGMutablePath()

            linePath.move(to: CGPoint(x: radius - radius/4.0 + radius/30.0, y: 0.0))

            linePath.addLine(to: CGPoint(x: radius - radius/4.0 + radius/15.0, y: 0.0))

            let transform = CGAffineTransform(rotationAngle: (CGFloat(tickValue) + 90.0 + gaugeAngle).deg2rad())
            tickScalesPath.addPath(linePath, transform: transform)
        }


        let tickShapeLayer = CAShapeLayer()
        tickShapeLayer.setAffineTransform(CGAffineTransform(translationX: center.x, y: center.y))
        tickShapeLayer.strokeColor = tickColor.cgColor
        tickShapeLayer.path = tickScalesPath
        tickShapeLayer.lineWidth = 2.0
        addSublayer(tickShapeLayer)
        tickRangesLayers?.append(tickShapeLayer)
    }
}
