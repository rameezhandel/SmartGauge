//
//  SGTrackLayer.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import QuartzCore
import UIKit

class SGTrackLayer: SGBaseLayer {
    
    //MARK: Public Properties
    public var gaugeTrackColor: UIColor = UIColor.lightGray {
        didSet { setupTrack() }
    }
    
    var gaugeRadioScale: CGFloat = 0.95 {
        didSet { setupTrack() }
    }

    var gaugeLineWidth: CGFloat = 20.0 {
        didSet { setupTrack() }
    }

    //MARK: Private properties
    private var trackLayer: CAShapeLayer?
    private var trackValueLayer: CAShapeLayer?

    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupTrack()
    }
    
    private func setupTrack() {
        trackLayer?.removeFromSuperlayer()
        trackValueLayer?.removeFromSuperlayer()

        trackLayer = CAShapeLayer()
        
        var trackColor = gaugeTrackColor
        for range in rangesList {
            if (gaugeValue ?? 0.0) <= range.toValue {
                trackColor = range.color ?? gaugeTrackColor
                break
            }
        }
        drawTrackLayer(trackLayer, value: gaugeMaxValue, strokeColor: trackColor.withAlphaComponent(0.1))
        addSublayer(trackLayer!)
        
        // Draw Track Value
        trackValueLayer = CAShapeLayer()
        drawTrackLayer(trackValueLayer, value: gaugeValue ?? 0.0, strokeColor: trackColor)
        addSublayer(trackValueLayer!)
    }
    
    private func drawTrackLayer(_ layer: CAShapeLayer?, value: CGFloat, strokeColor: UIColor) {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)*CGFloat(gaugeRadioScale)
        let gaugeMeterOffset = (gaugeAngle + 90.0).deg2rad()

        layer?.fillColor = nil

        let convertedValue = angleForValue(value)
        let val = convertedValue.deg2rad()

        layer?.lineWidth = gaugeLineWidth
        layer?.lineCap = .round
        layer?.strokeColor = strokeColor.cgColor

        let path = CGMutablePath()
        path.addArc(center: center, radius: radius, startAngle: gaugeMeterOffset , endAngle: gaugeMeterOffset + CGFloat(val), clockwise: false)

        layer?.path = path

    }
}
