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
    
    private var textLayer: CATextLayer?
    
    //MARK: Functions
    override func updateUI() {
        super.updateUI()
        setupValueTextLayer()
    }
    
    private func setupValueTextLayer() {
        
        textLayer?.removeFromSuperlayer()
        
        let radius = min(bounds.midX, bounds.midY) - 8.0
        
        let value = Int(gaugeValue ?? 0.0)

        textLayer = CATextLayer()
        textLayer?.font = CTFontCreateUIFontForLanguage(.system, radius/30.0, nil)
        textLayer?.fontSize = radius/3.0
        textLayer?.contentsScale = contentsScale
        textLayer?.foregroundColor = UIColor.black.cgColor
        textLayer?.string = "\(value)" // \(Int(CGFloat(value) / gaugeValuesScale + gaugeValuesOffset))"

        let size = textLayer?.preferredFrameSize() ?? CGSize.zero
        let yVal =  bounds.height - size.height - radius / 4
        textLayer?.frame = CGRect(x: (bounds.width - size.width)/2, y: yVal, width: size.width, height: size.height)
        textLayer?.alignmentMode = CATextLayerAlignmentMode.center
        addSublayer(textLayer!)

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