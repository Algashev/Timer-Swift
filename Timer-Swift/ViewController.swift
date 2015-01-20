//
//  ViewController.swift
//  Timer-Swift
//
//  Created by Александр Алгашев on 20.01.15.
//  Copyright (c) 2015 Александр Алгашев. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var timerPickerView: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var tapGestureHidePickerView: UITapGestureRecognizer!
    var timer = NSTimer()
    var timerInSeconds = NSTimeInterval()
    
    // MARK: Actions
    
    @IBAction func hideTimerPickerView(sender: AnyObject) {
        
        timerPickerView.hidden = true
        startButton.hidden = false
        
    }
    
    @IBAction func showTimerPickerView(sender: AnyObject) {
        
        startButton.hidden = true
        timerPickerView.hidden = false
        
    }
    
    @IBAction func startTimer(sender: AnyObject) {
        
        startButton.hidden = true
        stopButton.hidden = false
        pauseButton.hidden = false
        timerLabel.userInteractionEnabled = false
        tapGestureHidePickerView.enabled = false
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("countdownTimer"), userInfo: nil, repeats:true)
        
    }
    
    @IBAction func stopTimer(sender: AnyObject?) {
        
        startButton.hidden = false
        stopButton.hidden = true
        pauseButton.hidden = true
        timerLabel.userInteractionEnabled = true
        tapGestureHidePickerView.enabled  = true
        pauseButton.setTitle("Пауза", forState: UIControlState.Normal)
        
        timer.invalidate()
        
        timerPickerView.selectRow(1, inComponent: 0, animated: false)
        timerInSeconds = 60
        timerLabel.text = String(format: "%02i:%02i", Int(timerInSeconds / 60), Int(timerInSeconds % 60))
        
    }
    
    @IBAction func pauseTimer(sender: AnyObject) {
        
        if pauseButton.titleForState(UIControlState.Normal) == "Пауза" {
            
            pauseButton.setTitle("Дальше", forState: UIControlState.Normal)
            timer.invalidate()
            
        } else {
            
            pauseButton.setTitle("Пауза", forState: UIControlState.Normal)
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("countdownTimer"), userInfo: nil, repeats:true)
            
        }
        
    }
    
    func countdownTimer() {

        --timerInSeconds
        timerLabel.text = String(format: "%02i:%02i", Int(timerInSeconds / 60), Int(timerInSeconds % 60))
        
        if timerInSeconds == 0 {
            
            let alert = UIAlertController(title: "Timer", message: "Time is up", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            self.stopTimer(nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        timerPickerView.selectRow(1, inComponent: 0, animated: false)
        timerInSeconds = 60

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIPickerViewDataSource
    
    // The number of columns that the picker view should display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // The number of rows for the column
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (component == 0) ? 61 : 59;
    }
    
    // MARK: UIPickerViewDelegate
    
    // The string to use as the title of the indicated component row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return ("\(row)")
    }
    
    // Called by the picker view when the user selects a row in a component
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.selectedRowInComponent(0) == 0 && pickerView.selectedRowInComponent(1) == 0 {
            timerPickerView.selectRow(1, inComponent: 1, animated: true)
        }
        
        timerLabel.text = String(format: "%02i:%02i", pickerView.selectedRowInComponent(0), pickerView.selectedRowInComponent(1))
        timerInSeconds = Double(pickerView.selectedRowInComponent(0) * 60 + pickerView.selectedRowInComponent(1))

    }

}

