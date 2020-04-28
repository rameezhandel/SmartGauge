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
    
    public var trackBackgroundColor: UIColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 0.6) {
        didSet { setupTrack() }
    }

    public var enableRangeColorIndicator: Bool = true {
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
    private var rangeColorLayers: [CAShapeLayer] = []

    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupTrack()
    }
    
    private func setupTrack() {
        trackLayer?.removeFromSuperlayer()
        trackValueLayer?.removeFromSuperlayer()
        for rangeColorLayer in rangeColorLayers {
            rangeColorLayer.removeFromSuperlayer()
        }
        rangeColorLayers.removeAll()

        trackLayer = CAShapeLayer()

        var trackColor = gaugeTrackColor
        for range in rangesList {
            if (gaugeValue ?? 0.0) <= range.toValue {
                trackColor = range.color ?? gaugeTrackColor
                break
            }
        }
        drawTrackLayer(trackLayer, value: gaugeMaxValue, strokeColor: trackBackgroundColor)
        addSublayer(trackLayer!)

        // Draw Track Value
        trackValueLayer = CAShapeLayer()
        drawTrackLayer(trackValueLayer, value: gaugeValue ?? 0.0, strokeColor: trackColor)
        addSublayer(trackValueLayer!)
        
        // Draw Range Layer
        if enableRangeColorIndicator {
            drawRangeColorLayer()
        }
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
    
    private func drawRangeColorLayer() {
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.midX, bounds.midY)*CGFloat(gaugeRadioScale) - 25
        
        var startAngle: CGFloat = (gaugeAngle + 90.0).deg2rad()

        for (_, range) in rangesList.enumerated() {

            let convertedValue = angleForValue(range.toValue - range.fromValue).deg2rad()
            let endAngle = startAngle + convertedValue

            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            let colorRangeLayer = CAShapeLayer()
            colorRangeLayer.path = path.cgPath
            colorRangeLayer.strokeColor = range.color?.cgColor
            colorRangeLayer.fillColor = nil
            colorRangeLayer.lineWidth = 5.0
            
            addSublayer(colorRangeLayer)
            rangeColorLayers.append(colorRangeLayer)
            
            startAngle = endAngle
            
        }
        
    }
}
