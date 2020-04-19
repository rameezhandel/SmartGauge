//
//  ViewController.swift
//  SmartGauge
//
//  Created by rmz.rmz@live.com on 04/19/2020.
//  Copyright (c) 2020 rmz.rmz@live.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var gaugeView: SmartGauge!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupGaugeView()
    }

    private func setupGaugeView() {
        gaugeView.numberOfMajorTicks = 10
        gaugeView.numberOfMinorTicks = 3
        
        
        let first = SGRanges("first", fromValue: 0, toValue: 20, color: .blue)
        let second = SGRanges("second", fromValue: 20, toValue: 40, color: .green)
        let third = SGRanges("third", fromValue: 40, toValue: 80, color: .red)

        gaugeView.rangesList = [first, second, third]
        gaugeView.gaugeMaxValue = third.toValue
        gaugeView.gaugeAngle = 60
        gaugeView.gaugeTrackColor = UIColor.blue
        gaugeView.gaugeValue = 20

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

