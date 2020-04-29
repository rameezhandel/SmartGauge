//
//  SGBaseLayer.swift
//  SmartGauge
//
//  Created by Rameez on 4/15/20.
//  Copyright © 2020 Rameez. All rights reserved.
//

import QuartzCore

class SGBaseLayer: CALayer {

    //MARK: Public Properties
    public var gaugeType: SGType = .gauge {
        didSet { updateUI() }
    }

    var numberOfMajorTicks: Int = 5 {
        didSet { updateUI() }
    }

    public var gaugeValue: CGFloat? {
        didSet { updateUI() }
    }

    public var gaugeAngle: CGFloat = 0.0 {
        didSet { updateUI() }
    }

    public var gaugeMaxValue: CGFloat = 360.0 {
        didSet { updateUI() }
    }

    public var rangesList: [SGRanges] = [] {
        didSet {  updateUI() }
    }

    //MARK: Functions
    internal func updateUI() {}

    internal func angleForValue(_ value: CGFloat) -> CGFloat {
        let laregstAngle = gaugeMaxValue
        let gaugeMeterOffset = gaugeAngle * 2.0
        
        let totalAngle = 360 - gaugeMeterOffset
        let convertedAngle = totalAngle * value / laregstAngle
        return convertedAngle
    }

}

extension CGFloat {
    func rounded(_ places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
