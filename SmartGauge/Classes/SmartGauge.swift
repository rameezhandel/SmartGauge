//
//  SmartGauge.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import UIKit

public class SmartGauge: UIView {
    
    //MARK: Public Properties
    public var numberOfMajorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var numberOfMinorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var tickColor: UIColor = UIColor.lightGray {
        didSet { updateUI() }
    }
    
    public var coveredTickValueColor: UIColor = UIColor.black {
        didSet { updateUI() }
    }

    public var uncoveredTickValueColor: UIColor = UIColor.lightGray {
        didSet { updateUI() }
    }

    public var decimalPlaces: Int = 2 {
        didSet { updateUI() }
    }

    public var valueFontSize: CGFloat? {
        didSet { updateUI() }
    }

    public var valueTextColor: UIColor = UIColor.black {
        didSet { updateUI() }
    }

    public var valueFont: UIFont = UIFont.systemFont(ofSize: 20) {
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
        didSet { updateUI() }
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
        backgroundColor = .clear
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        updateUI()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
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
        tickLayer?.tickColor = tickColor
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
        tickValuesLayer?.coveredTickValueColor = coveredTickValueColor
        tickValuesLayer?.uncoveredTickValueColor = uncoveredTickValueColor
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
        selectedValueLayer?.decimalPlaces = decimalPlaces
        selectedValueLayer?.valueTextColor = valueTextColor
        selectedValueLayer?.valueFontSize = valueFontSize
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
    public var title: String?
    public var fromValue: CGFloat = 0.0
    public var toValue: CGFloat = 0.0
    public var color: UIColor?
    
    public init(_ title: String?, fromValue: CGFloat, toValue: CGFloat,  color: UIColor?) {
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

