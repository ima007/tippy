//
//  ViewController.swift
//  tips
//
//  Created by Shane Afsar on 12/14/14.
//  Copyright (c) 2014 safsar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var totalTwoWaysLabel: UILabel!
    @IBOutlet weak var totalThreeWaysLabel: UILabel!
    @IBOutlet weak var totalFourWaysLabel: UILabel!
    @IBOutlet weak var totalAndTipsViews: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
 
    let zeroCurrency = (0.0).asCurrency
    
    var settings = SettingsStore()
    
    //Flag which maintains the animation state
    var openTotals = false
    
    //Used to store initial positions of the input amount
    //and the output area
    var yPositions = (label:CGFloat(), total:CGFloat())
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if settings.isDarkTheme {
            setDarkThemeValues()
        }else{
            setLightThemeValues()
        }
        
        // Reset controls/labels if any settings changed
        tipControl.selectedSegmentIndex = settings.defaultTipIndex
        var calc = tipAndTotal(billField.text.asDoubleValue)
        updateLabels(calc.total, tip:calc.tip);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "appDidBecomeActive:",
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        
        billField.becomeFirstResponder()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDarkThemeValues(){
        
        view.tintColor = .blackColor()
        view.backgroundColor = .blackColor()
        
        billField.textColor = .whiteColor()
        billField.attributedPlaceholder = NSAttributedString(string: "Enter bill", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        billField.tintColor = .whiteColor()
        
        tipControl.tintColor = .whiteColor()
        
        totalAndTipsViews.tintColor = .whiteColor()
        
        totalAndTipsViews.updateViewLabels(.lightTextColor())
        
        totalAndTipsViews.backgroundColor = .blackColor()
    }
    
    func setLightThemeValues(){
        view.tintColor = .whiteColor()
        view.backgroundColor = .whiteColor()
        
        billField.textColor = .greenColor()
        billField.attributedPlaceholder = NSAttributedString(string: "Enter bill", attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        
        billField.tintColor = .whiteColor()
        
        tipControl.tintColor = .blueColor()
        
        totalAndTipsViews.tintColor = .blackColor()
        
        totalAndTipsViews.updateViewLabels(.darkTextColor())
        
        totalAndTipsViews.backgroundColor = .whiteColor()

    }
    
    func refresh(){
        if settings.shouldClearValues {
            settings.clearValues()
            billField.text = ""
            tipLabel.text = zeroCurrency
            totalLabel.text = zeroCurrency
            totalTwoWaysLabel.text = zeroCurrency
            totalThreeWaysLabel.text = zeroCurrency
            totalFourWaysLabel.text = zeroCurrency
        }else{
            billField.text = settings.lastBillAmount.asCurrency
        }
    }
    
    func appDidBecomeActive(notification: NSNotification) {
        refresh()
    }
    
    func roundedTotalTips(total: Double, tip: Double) -> (total: Double, tip: Double){
        var totalRounded = round(total)
        var totalDifference = totalRounded - total
        var modifiedTip = tip + totalDifference
        
        return (total: totalRounded, tip: modifiedTip)
    }
    
    func showTotals(){
        if openTotals{
            var billFrame = billField.frame
            var totalFrame = totalAndTipsViews.frame
            yPositions.total = totalFrame.origin.y
            yPositions.label = billFrame.origin.y
            
            UIView.animateWithDuration(0.7, delay:0.0, options: .CurveEaseOut, animations:{
                
                billFrame.origin.y -= 80
                totalFrame.origin.y -= 80
                self.totalAndTipsViews.alpha = 1
            
                self.billField.frame = billFrame
                self.totalAndTipsViews.frame = totalFrame
                }, completion: { finished in
            })
        }
    }
    
    func hideTotals(){
        if !openTotals{
            var billFrame = self.billField.frame
            var totalFrame = self.totalAndTipsViews.frame
            
            UIView.animateWithDuration(0.7, delay:0.0, options: .CurveEaseOut, animations:{
                billFrame.origin.y = self.yPositions.label
                totalFrame.origin.y = self.yPositions.total
                self.totalAndTipsViews.alpha = 0
                
                self.billField.frame = billFrame
                self.totalAndTipsViews.frame = totalFrame
                }, completion: { finished in
            })
        }
    }
    
    func transitionViews(billAmount: Double){
        if billAmount > 0.0{
            if !openTotals {
                openTotals = true
                showTotals()
            }
        }else{
            openTotals = false
            hideTotals()
        }
    }
    
    func updateSettings(billAmount: Double){
        if settings.lastBillAmount != billAmount{
            settings.setLastBillAmount(billAmount)
            settings.setLastEditTime()
        }
    }
    
    func tipAndTotal(billAmount: Double) -> (total:Double, tip:Double){
        
        var tipPercentage = settings.defaultTipPercents[tipControl.selectedSegmentIndex]
        
        var tip = billAmount * tipPercentage
        var total = billAmount + tip
        
        if settings.alwaysRoundTips {
            var rounded = roundedTotalTips(total, tip: tip)
            tip = rounded.tip
            total = rounded.total
        }
        
        return (total:total, tip:tip)
    }
    
    func updateLabels(total: Double, tip: Double){
        tipLabel.text = tip.asCurrency
        totalLabel.text = total.asCurrency
        totalTwoWaysLabel.text = (total/2).asCurrency
        totalThreeWaysLabel.text = (total/3).asCurrency
        totalFourWaysLabel.text = (total/4).asCurrency
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        var billAmount = billField.text.asDoubleValue
        
        transitionViews(billAmount)
        updateSettings(billAmount)
        
        var calc = tipAndTotal(billAmount)
        updateLabels(calc.total, tip:calc.tip);
       
    }
    
    @IBAction func swipeUp(sender: AnyObject) {
        performSegueWithIdentifier("segueToSettings", sender: self)
    }

}

