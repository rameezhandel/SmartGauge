//
//  SmartGauge.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import UIKit

class SmartGauge: UIView {
    
    //MARK: Public Properties
    public var numberOfMajorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var numberOfMinorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var gaugeValue: CGFloat? {
        didSet { updateUI() }
    }

    public var gaugeLineWidth: CGFloat = 20.0 {
        didSet { updateUI() }
    }

    public var gaugeMaxValue: CGFloat = 100.0 {
        didSet { updateUI() }
    }

    public var gaugeAngle: CGFloat = 45.0 {
        didSet { updateUI() }
    }
    
    public var gaugeTrackColor: UIColor = UIColor.lightGray {
        didSet { updateUI() }
    }

    public var rangesList: [SGRanges] = [] {
        didSet {  }
    }

    //MARK: Private Properties
    private var trackLayer: SGTrackLayer?
    private var tickLayer: SGTickLayer?
    private var tickValuesLayer: SGTickValuesLayer?
    private var selectedValueLayer: SGGaugeValueLayer?
    private var handleLayer: SGHandleLayer?

    //MARK: Functions
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateUI()
    }

    private func updateUI() {
        setupTrackLayer()
        setupTickLayer()
        setupTickValuesLayer()
        setupSelectedValueTextLayer()
        setupHandleLayer()
    }
    
    private func setupTrackLayer() {
        trackLayer?.removeFromSuperlayer()
        trackLayer = SGTrackLayer()
        trackLayer?.frame = layer.bounds
        trackLayer?.gaugeAngle = gaugeAngle
        trackLayer?.gaugeValue = gaugeValue
        trackLayer?.gaugeMaxValue = gaugeMaxValue
        trackLayer?.gaugeLineWidth = gaugeLineWidth
        trackLayer?.rangesList = rangesList
        trackLayer?.gaugeTrackColor = gaugeTrackColor
        trackLayer.map { layer.addSublayer($0) }
    }
    
    private func setupTickLayer() {
        tickLayer?.removeFromSuperlayer()
        tickLayer = SGTickLayer()
        tickLayer?.frame = layer.bounds
        tickLayer?.gaugeAngle = gaugeAngle
        tickLayer?.gaugeValue = gaugeValue
        tickLayer?.gaugeMaxValue = gaugeMaxValue
        tickLayer?.numberOfMajorTicks = numberOfMajorTicks
        tickLayer?.numberOfMinorTicks = numberOfMinorTicks
        tickLayer.map { layer.addSublayer($0) }
    }

    private func setupTickValuesLayer() {
        tickValuesLayer?.removeFromSuperlayer()
        tickValuesLayer = SGTickValuesLayer()
        tickValuesLayer?.frame = layer.bounds
        tickValuesLayer?.gaugeAngle = gaugeAngle
        tickValuesLayer?.gaugeValue = gaugeValue
        tickValuesLayer?.gaugeMaxValue = gaugeMaxValue
        tickValuesLayer?.numberOfMajorTicks = numberOfMajorTicks
        tickValuesLayer.map { layer.addSublayer($0) }
    }

    private func setupSelectedValueTextLayer() {
        selectedValueLayer?.removeFromSuperlayer()
        selectedValueLayer = SGGaugeValueLayer()
        selectedValueLayer?.frame = layer.bounds
        selectedValueLayer?.gaugeAngle = gaugeAngle
        selectedValueLayer?.gaugeValue = gaugeValue
        selectedValueLayer?.gaugeMaxValue = gaugeMaxValue
        selectedValueLayer?.numberOfMajorTicks = numberOfMajorTicks
        selectedValueLayer.map { layer.addSublayer($0) }
    }

    private func setupHandleLayer() {
        handleLayer?.removeFromSuperlayer()
        handleLayer = SGHandleLayer()
        handleLayer?.frame = layer.bounds
        handleLayer?.gaugeAngle = gaugeAngle
        handleLayer?.gaugeValue = gaugeValue
        handleLayer?.gaugeMaxValue = gaugeMaxValue
        handleLayer?.numberOfMajorTicks = numberOfMajorTicks
        handleLayer?.rangesList = rangesList
        handleLayer.map { layer.addSublayer($0) }
    }

}


public class SGRanges {
    var title: String?
    var fromValue: CGFloat = 0.0
    var toValue: CGFloat = 0.0
    var color: UIColor?
    
    init(_ title: String?, fromValue: CGFloat, toValue: CGFloat,  color: UIColor?) {
        self.title = title
        self.fromValue = fromValue
        self.toValue = toValue
        self.color = color
    }
}

extension CGFloat {
    
    func deg2rad() -> CGFloat {
        return self * .pi / 180
    }

    func rad2Deg() -> CGFloat {
        return self * 180 / .pi
    }
}

