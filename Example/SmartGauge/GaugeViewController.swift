//
//  GaugeViewController.swift
//  SmartGauge_Example
//
//  Created by Rameez on 4/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SmartGauge

class GaugeViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var gaugeView: SmartGauge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupGaugeView()
        setupSlider()
    }
    
    private func setupGaugeView() {
        gaugeView.numberOfMajorTicks = 10
        gaugeView.numberOfMinorTicks = 3
        
        gaugeView.gaugeAngle = 60
        gaugeView.gaugeValue = 30
        gaugeView.gaugeTrackColor = UIColor.blue
        gaugeView.enableLegends = false
        gaugeView.gaugeViewPercentage = 0.75
        gaugeView.legendSize = CGSize(width: 25, height: 20)
        if let font = CTFontCreateUIFontForLanguage(.system, 30.0, nil) {
            gaugeView.legendFont = font
        }
        
        let first = SGRanges("0 - 20", fromValue: 0, toValue: 20, color: GaugeRangeColorsSet.first)
        let second = SGRanges("20 - 40", fromValue: 20, toValue: 40, color: GaugeRangeColorsSet.second)
        let third = SGRanges("40 - 80", fromValue: 40, toValue: 80, color: GaugeRangeColorsSet.third)
        let fourth = SGRanges("80 - 90", fromValue: 80, toValue: 90, color: GaugeRangeColorsSet.fourth)
        let fifth = SGRanges("90 - 100", fromValue: 90, toValue: 100, color: GaugeRangeColorsSet.fifth)
        let sixth = SGRanges("100 - 120", fromValue: 100, toValue: 120, color: GaugeRangeColorsSet.sixth)
        
        gaugeView.rangesList = [first, second, third, fourth, fifth, sixth]
        gaugeView.gaugeMaxValue = sixth.toValue
        gaugeView.enableRangeColorIndicator = true
    }
    
    private func setupSlider() {
        //Slider Setup
        slider.maximumValue = Float(gaugeView.gaugeMaxValue)
        slider.minimumValue = Float(0)
        slider.value = Float(gaugeView.gaugeValue!)
    }
    
    //MARK: Actions
    @IBAction func sliderValueChange(_ sender: UISlider) {
        gaugeView.gaugeValue = CGFloat(slider.value)
    }
    
}

struct GaugeRangeColorsSet {
    static var first: UIColor   { return UIColor.colorFromHexString("#1700FF") }
    static var second: UIColor  { return UIColor.colorFromHexString("#3A7CCC") }
    static var third: UIColor   { return UIColor.colorFromHexString("#3DAABF") }
    static var fourth: UIColor  { return UIColor.colorFromHexString("#3BDBA6") }
    static var fifth: UIColor   { return UIColor.colorFromHexString("#21A579") }
    static var sixth: UIColor   { return UIColor.colorFromHexString("#02724D") }
    static var seventh: UIColor { return UIColor.colorFromHexString("#00442E") }
    
    static var all: [UIColor] = [first, second, third, fourth, fifth, sixth, seventh]
}

extension UIColor {
    static func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
