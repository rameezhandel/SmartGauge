//
//  GoalViewController.swift
//  SmartGauge_Example
//
//  Created by Rameez on 4/29/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import SmartGauge

class GoalViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var gaugeView: SmartGauge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupGoalView()
        setupSlider()
    }
    
    private func setupGoalView() {
        gaugeView.gaugeType = .goal
        gaugeView.gaugeAngle = 60
        gaugeView.gaugeValue = 40
        gaugeView.gaugeTrackColor = UIColor.blue
        gaugeView.enableLegends = true
        gaugeView.gaugeViewPercentage = 0.75
        gaugeView.legendSize = CGSize(width: 25, height: 20)
        if let font = CTFontCreateUIFontForLanguage(.system, 30.0, nil) {
            gaugeView.legendFont = font
        }
        gaugeView.gaugeTrackWidth = 20.0
        gaugeView.gaugeValueTrackWidth = 35.0
        //        gaugeView.legendSize = CGSize.zero
        
        let first = SGRanges("Goal: 200", fromValue: 0, toValue: 200, color: GaugeRangeColorsSet.first)
        gaugeView.rangesList = [first]
        gaugeView.gaugeMaxValue = first.toValue
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
