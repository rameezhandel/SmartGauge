//
//  SmartGauge.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import UIKit

public enum SGType {
    case gauge
    case goal
}

public class SmartGauge: UIView {
        
    //MARK: Public Properties
    public var gaugeType: SGType = .gauge {
        didSet { updateUI() }
    }
    
    public var numberOfMajorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var numberOfMinorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var enableLegends: Bool = true {
        didSet { updateUI() }
    }

    public var legendMargin: CGFloat = 15.0 {
        didSet { updateUI() }
    }

    public var legendSpacing: CGFloat = 10.0 {
        didSet { updateUI() }
    }

    public var legendVerticalSpacing: CGFloat = 10.0 {
        didSet { updateUI() }
    }

    public var enableRangeColorIndicator: Bool = true {
        didSet { updateUI() }
    }

    /// The range should be 0 to 1. Applicable only if enableLegends = TRUE
    public var gaugeViewPercentage: CGFloat = 0.75 {
        didSet { updateUI() }
    }

    public var legendFont: CTFont = CTFontCreateUIFontForLanguage(.system, 25, nil) ?? CTFontCreateWithName("Helvetica" as CFString, 25, nil) {
        didSet { updateUI() }
    }

    public var legendSize: CGSize = CGSize(width: 25, height: 25) {
        didSet { updateUI() }
    }
    
    public var legendCornerRadius: CGFloat = 5.0 {
        didSet { updateUI() }
    }

    public var titleText: String = "" {
        didSet { updateUI() }
    }
    
    public var titleFontSize: CGFloat? {
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
    
    public var tickValueFontSize: CGFloat? {
        didSet { updateUI() }
    }

    public var gaugeValue: CGFloat? {
        didSet { updateUI() }
    }

    public var gaugeValueTrackWidth: CGFloat = 20.0 {
        didSet { updateUI() }
    }

    public var gaugeTrackWidth: CGFloat = 20.0 {
        didSet { updateUI() }
    }

    public var gaugeMaxValue: CGFloat = 100.0 {
        didSet { updateUI() }
    }

    public var gaugeAngle: CGFloat = 60.0 {
        didSet { updateUI() }
    }
    
    public var trackBackgroundColor: UIColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 0.6) {
        didSet { updateUI() }
    }

    public var gaugeTrackColor: UIColor = UIColor.lightGray {
        didSet { updateUI() }
    }

    public var rangesList: [SGRanges] = [] {
        didSet {
            rangesUpdated()
            updateUI()
        }
    }

    //MARK: Private Properties
    private var gaugeHolderLayer: CALayer   =   CALayer()
    private var legendsHolderLayer: CALayer =   CALayer()

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

    //MARK: Private Functions
    private func updateUI() {
        removeAllLayers()
        
        setupBaseLayers()
        setupTrackLayer()

        if gaugeType == .gauge {
            setupTickLayer()
            setupTickValuesLayer()
            setupHandleLayer()
        } else {
            trackLayer?.enableRangeColorIndicator = false
        }
        setupSelectedValueTextLayer()
    }
    
    private func rangesUpdated() {
        
        // Create legends only if lenegds enabled
        guard enableLegends else { return }
        setupLegends()
    }
    
    private func removeAllLayers() {
        gaugeHolderLayer.removeFromSuperlayer()
        legendsHolderLayer.removeFromSuperlayer()
        trackLayer?.removeFromSuperlayer()
        tickLayer?.removeFromSuperlayer()
        tickValuesLayer?.removeFromSuperlayer()
        selectedValueLayer?.removeFromSuperlayer()
        handleLayer?.removeFromSuperlayer()
    }
    
    private func setupBaseLayers() {
        
        gaugeHolderLayer.removeFromSuperlayer()
        legendsHolderLayer.removeFromSuperlayer()

        // Setup Gauge Holder Layer
        let multiplier = enableLegends ? gaugeViewPercentage : 1
        let gaugeHeight = layer.bounds.height * multiplier
        let gaugeYVal = (layer.bounds.height - gaugeHeight) / 2
        let gaugeHolderFrame = CGRect(x: 0, y: gaugeYVal, width: layer.bounds.width * multiplier, height: gaugeHeight)
        gaugeHolderLayer.frame = gaugeHolderFrame
        layer.addSublayer(gaugeHolderLayer)
        // Create legends only if lenegds enabled
        guard enableLegends else { return }
        // Setup Legends holder Layer
        let xVal = gaugeHolderFrame.width
        let width = layer.bounds.width - gaugeHolderFrame.width
        let legendsHolderFrame = CGRect(x: xVal, y: 0, width: width, height: layer.bounds.height)
        legendsHolderLayer.frame = legendsHolderFrame
        layer.addSublayer(legendsHolderLayer)
    }
    
    private func setupLegends() {
        for (index, range) in rangesList.enumerated() {
            // TextLayer
            let legendTextLayer = CATextLayer()
            legendTextLayer.font = legendFont
            legendTextLayer.fontSize = CTFontGetSize(legendFont)
            
            legendTextLayer.string = range.title
            legendTextLayer.foregroundColor = valueTextColor.cgColor
            let textFrameSize = legendTextLayer.preferredFrameSize()
            
            var legendTextyValue = CGFloat(index) * textFrameSize.height + CGFloat(index + 1) * legendVerticalSpacing
            var legendYValue = CGFloat(index) * legendSize.height +  CGFloat(index + 1) * legendVerticalSpacing

            let remainingSpaceMultiplier = 2 * CGFloat(index) + 1
            if textFrameSize.height > legendSize.height {
                legendYValue += ((textFrameSize.height - legendSize.height) * remainingSpaceMultiplier / 2)
            } else if legendSize.height > textFrameSize.height {
                legendTextyValue += ((legendSize.height - textFrameSize.height) * remainingSpaceMultiplier  / 2)
            }
            
            let xValue = legendMargin + legendSpacing + legendSize.width
            legendTextLayer.frame = CGRect(x: xValue, y: legendTextyValue, width: textFrameSize.width, height: textFrameSize.height)
            legendsHolderLayer.addSublayer(legendTextLayer)
            
            // Create legend
            let legend = CAShapeLayer()
            legend.path = UIBezierPath(roundedRect: CGRect(x: legendMargin, y: legendYValue, width: legendSize.width, height: legendSize.height), cornerRadius: legendCornerRadius).cgPath
            legend.fillColor = range.color?.cgColor ?? UIColor.gray.cgColor
            legendsHolderLayer.addSublayer(legend)
        }
    }
    
    private func setupTrackLayer() {
        trackLayer?.removeFromSuperlayer()
        trackLayer = SGTrackLayer()
        trackLayer?.frame = gaugeHolderLayer.bounds
        trackLayer?.gaugeAngle = gaugeAngle
        trackLayer?.gaugeValue = gaugeValue
        trackLayer?.gaugeMaxValue = gaugeMaxValue
        trackLayer?.gaugeTrackWidth = gaugeTrackWidth
        trackLayer?.gaugeValueTrackWidth = gaugeValueTrackWidth
        trackLayer?.rangesList = rangesList
        trackLayer?.gaugeTrackColor = gaugeTrackColor
        trackLayer?.trackBackgroundColor = trackBackgroundColor
        trackLayer?.enableRangeColorIndicator = enableRangeColorIndicator
        trackLayer.map { gaugeHolderLayer.addSublayer($0) }
    }
    
    private func setupTickLayer() {
        tickLayer?.removeFromSuperlayer()
        tickLayer = SGTickLayer()
        tickLayer?.frame = gaugeHolderLayer.bounds
        tickLayer?.gaugeAngle = gaugeAngle
        tickLayer?.gaugeValue = gaugeValue
        tickLayer?.gaugeMaxValue = gaugeMaxValue
        tickLayer?.numberOfMajorTicks = numberOfMajorTicks
        tickLayer?.numberOfMinorTicks = numberOfMinorTicks
        tickLayer?.tickColor = tickColor
        tickLayer.map { gaugeHolderLayer.addSublayer($0) }
    }

    private func setupTickValuesLayer() {
        tickValuesLayer?.removeFromSuperlayer()
        tickValuesLayer = SGTickValuesLayer()
        tickValuesLayer?.frame = gaugeHolderLayer.bounds
        tickValuesLayer?.gaugeAngle = gaugeAngle
        tickValuesLayer?.gaugeValue = gaugeValue
        tickValuesLayer?.gaugeMaxValue = gaugeMaxValue
        tickValuesLayer?.numberOfMajorTicks = numberOfMajorTicks
        tickValuesLayer?.coveredTickValueColor = coveredTickValueColor
        tickValuesLayer?.uncoveredTickValueColor = uncoveredTickValueColor
        tickValuesLayer?.tickValueFontSize = tickValueFontSize
        tickValuesLayer.map { gaugeHolderLayer.addSublayer($0) }
    }

    private func setupSelectedValueTextLayer() {
        selectedValueLayer?.removeFromSuperlayer()
        selectedValueLayer = SGGaugeValueLayer()
        selectedValueLayer?.frame = gaugeHolderLayer.bounds
        selectedValueLayer?.gaugeType = gaugeType
        selectedValueLayer?.gaugeAngle = gaugeAngle
        selectedValueLayer?.gaugeValue = gaugeValue
        selectedValueLayer?.gaugeMaxValue = gaugeMaxValue
        selectedValueLayer?.numberOfMajorTicks = numberOfMajorTicks
        selectedValueLayer?.decimalPlaces = decimalPlaces
        selectedValueLayer?.valueTextColor = valueTextColor
        selectedValueLayer?.valueFontSize = valueFontSize
        selectedValueLayer?.valueFont = valueFont
        selectedValueLayer?.titleText = titleText
        selectedValueLayer?.titleFontSize = titleFontSize
        selectedValueLayer.map { gaugeHolderLayer.addSublayer($0) }
    }

    private func setupHandleLayer() {
        handleLayer?.removeFromSuperlayer()
        handleLayer = SGHandleLayer()
        handleLayer?.frame = gaugeHolderLayer.bounds
        handleLayer?.gaugeAngle = gaugeAngle
        handleLayer?.gaugeValue = gaugeValue
        handleLayer?.gaugeMaxValue = gaugeMaxValue
        handleLayer?.numberOfMajorTicks = numberOfMajorTicks
        handleLayer?.rangesList = rangesList
        handleLayer.map { gaugeHolderLayer.addSublayer($0) }
    }

}


public class SGRanges {
    public var title: String?
    public var fromValue: CGFloat = 0.0
    public var toValue: CGFloat = 0.0
    public var color: UIColor?
    
    public init(_ title: String?, fromValue: CGFloat, toValue: CGFloat,  color: UIColor) {
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

