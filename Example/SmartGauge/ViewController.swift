//
//  ViewController.swift
//  SmartGauge
//
//  Created by rmz.rmz@live.com on 04/19/2020.
//  Copyright (c) 2020 rmz.rmz@live.com. All rights reserved.
//

import UIKit
import SmartGauge

class ViewController: UIViewController {

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
        gaugeView.gaugeValue = 0
        gaugeView.gaugeTrackColor = UIColor.blue
        gaugeView.enableLegends = true
        gaugeView.gaugeViewPercentage = 0.75
        gaugeView.legendSize = CGSize(width: 25, height: 20)
        if let font = CTFontCreateUIFontForLanguage(.system, 30.0, nil) {
            gaugeView.legendFont = font
        }

        let first = SGRanges("0 - 20", fromValue: 0, toValue: 20, color: .blue)
        let second = SGRanges("20 - 40", fromValue: 20, toValue: 40, color: .green)
        let third = SGRanges("40 - 80", fromValue: 0, toValue: 80, color: .red)
        let fourth = SGRanges("80 - 90", fromValue: 80, toValue: 90, color: .cyan)
        let fifth = SGRanges("90 - 100", fromValue: 90, toValue: 100, color: .orange)
        let sixth = SGRanges("100 - 120", fromValue: 100, toValue: 120, color: .systemPink)

        gaugeView.rangesList = [first, second, third, fourth, fifth, sixth]
        gaugeView.gaugeMaxValue = sixth.toValue

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

