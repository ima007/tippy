//
//  SettingsViewController.swift
//  tips
//
//  Created by Shane Afsar on 12/14/14.
//  Copyright (c) 2014 safsar. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var settings = SettingsStore()
    
    @IBOutlet weak var alwaysRoundUpSwitch: UISwitch!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var localeControl: UISegmentedControl!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure the switch is in the correct state.
        alwaysRoundUpSwitch.on = settings.alwaysRoundTips
        
        // Ensure the default tip amount is in the correct state
        defaultTipControl.selectedSegmentIndex = settings.defaultTipIndex
        
        //Ensure locale tester control is in the correct state
        localeControl.selectedSegmentIndex = settings.localeIndex;
        
        //Ensure dark theme switch has the correct state
        darkThemeSwitch.on = settings.isDarkTheme;
        
        if settings.isDarkTheme {
            setDarkThemeValues()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDarkThemeValues(){
        navigationBar.barStyle = .Black
        closeButton.tintColor = .whiteColor()
        view.backgroundColor = .blackColor()
        view.tintColor = .whiteColor()
        view.updateViewLabels(.whiteColor())
    }
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onLocaleChange(sender: AnyObject) {
        settings.setLocale(settings.localeTestValues[localeControl.selectedSegmentIndex])
    }
    
    @IBAction func onSwitchChanged(sender: AnyObject) {
        settings.setTipRounding(alwaysRoundUpSwitch.on)
    }
    
    @IBAction func onDarkThemeChanged(sender: AnyObject) {
        // Assuming multi-theme support in the future
        if darkThemeSwitch.on {
            settings.setTheme("dark")
        }else{
            settings.setTheme("light")
        }
    }
    
    @IBAction func onDefaultTipChanged(sender: AnyObject) {
        var tipPercent = settings.defaultTipPercents[defaultTipControl.selectedSegmentIndex]
        settings.setDefaultTip(tipPercent)
    }
}
