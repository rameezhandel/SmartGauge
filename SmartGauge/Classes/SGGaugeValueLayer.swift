//
//  SGGaugeValueLayer.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import QuartzCore
import UIKit

class SGGaugeValueLayer: SGBaseLayer {
    
    var decimalPlaces: Int = 2 {
        didSet { updateUI() }
    }

    public var valueFontSize: CGFloat? {
        didSet { updateUI() }
    }
    
    public var valueFont: UIFont? {
        didSet { updateUI() }
    }

    public var titleFontSize: CGFloat? {
        didSet { updateUI() }
    }

    public var valueTextColor: UIColor = UIColor.black {
        didSet { updateUI() }
    }

    public var titleText: String = "" {
        didSet { updateUI() }
    }

    private var textLayer: CATextLayer?
    private var titleLayer: CATextLayer?

    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupValueTextLayer()
        setupTitleTextLayer()
    }
    
    private func setupValueTextLayer() {
        
        textLayer?.removeFromSuperlayer()
        
        let radius = min(bounds.midX, bounds.midY) - 8.0
        
        let value = (gaugeValue ?? 0.0).rounded(2)
        var displayVal = "\(value)"
        if value != 0 {
            displayVal = NSNumber(value: Float(value)).thousandSeperator(2) ?? "\(value)"
        }

        textLayer = CATextLayer()
        if #available(iOS 8.2, *) {
            textLayer?.font = valueFont ?? UIFont.systemFont(ofSize: 20, weight: .regular)
        } else {
            // Fallback on earlier versions
            textLayer?.font = CTFontCreateUIFontForLanguage(.system, radius/30.0, nil)
        }
        textLayer?.fontSize = valueFontSize ?? radius/3.0
        textLayer?.contentsScale = contentsScale
        textLayer?.foregroundColor = valueTextColor.cgColor
        textLayer?.string = displayVal

        let size = textLayer?.preferredFrameSize() ?? CGSize.zero
        var yVal: CGFloat =  0.0
        if gaugeType == .gauge {
            yVal = bounds.height - size.height - radius / 4
        } else {
            yVal = (bounds.height - size.height)/2
        }
        
        textLayer?.frame = CGRect(x: (bounds.width - size.width)/2, y: yVal, width: size.width, height: size.height)
        textLayer?.alignmentMode = CATextLayerAlignmentMode.center
        addSublayer(textLayer!)
    }
    
    private func setupTitleTextLayer() {
        
        titleLayer?.removeFromSuperlayer()
        
        let radius = min(bounds.midX, bounds.midY) - 8.0
        
        titleLayer = CATextLayer()
        titleLayer?.font = CTFontCreateUIFontForLanguage(.system, radius/15.0, nil)
        titleLayer?.fontSize = titleFontSize ?? radius/3.0
        titleLayer?.contentsScale = contentsScale
        titleLayer?.foregroundColor = valueTextColor.cgColor
        titleLayer?.string = titleText

        let size = titleLayer?.preferredFrameSize() ?? CGSize.zero
        var yVal: CGFloat =  0.0
        let referenceVal = textLayer?.frame.origin.y ?? bounds.height
        if gaugeType == .gauge {
            yVal = referenceVal - size.height - radius / 4
        } else {
            yVal = (referenceVal - size.height)
        }

        titleLayer?.frame = CGRect(x: (bounds.width - size.width)/2, y: yVal, width: size.width, height: size.height)
        titleLayer?.alignmentMode = CATextLayerAlignmentMode.center
        addSublayer(titleLayer!)
    }

}

extension String {
    
    func sizeOfString(_ font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    func heightOfString(_ font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

}

extension NSNumber {
    func thousandSeperator(_ places: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = places
        return formatter.string(for: self) ?? ""
    }

}
