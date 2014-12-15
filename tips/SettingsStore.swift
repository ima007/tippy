//
//  SettingsStore.swift
//  tips
//
//  Created by Shane Afsar on 12/14/14.
//  Copyright (c) 2014 safsar. All rights reserved.
//

import Foundation

class SettingsStore{
    private let alwaysRoundKey = "always_round_up"
    private let defaultTipKey = "default_tip_amount"
    private let lastEditDateKey = "last_edit_date"
    private let lastAmountKey = "last_amount"
    private let localeSettingKey = "locale_setting"
    private let themeSettingKey = "theme_setting"
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    // TODO: make these tip tiers configurable
    let defaultTipPercents = [0.15, 0.18, 0.2, 0.22]
    
    let localeTestValues = ["en_US","en_GB","fr_FR","ja_JP"]
    
    // It's set to a really small value for demo-purposes
    let cacheAmountTimeInSeconds = 5.0
    
    var alwaysRoundTips: Bool {
        return defaults.boolForKey(alwaysRoundKey)
    }
    
    var defaultTipAmount: Double {
        return defaults.doubleForKey(defaultTipKey)
    }
    
    var defaultTipIndex: Int {
        var index = find(defaultTipPercents, defaultTipAmount)
        if index != nil {
            return index!
        }
        return -1
    }
    
    var localeTest: NSLocale{
        var id = defaults.objectForKey(localeSettingKey) as String?
        
        if id != nil{
            return NSLocale(localeIdentifier: id!)
        }
        return NSLocale.currentLocale()
    }
    
    var localeIndex: Int{
        var id = defaults.objectForKey(localeSettingKey) as String?
        
        if id != nil {
            var index = find(localeTestValues, id!)
        
            if index != nil {
                return index!
            }
        }
        return -1
    }
    
    var isDarkTheme: Bool{
        var themeName = defaults.objectForKey(themeSettingKey) as String?
        if themeName != nil{
            return themeName! == "dark"
        }
        return false
    }
    
    var lastEditDate: NSDate?{
        return defaults.objectForKey(lastEditDateKey) as NSDate?
    }
    
    var shouldClearValues: Bool{
        if lastEditDate != nil{
            var timeSinceLastEdit = NSDate().timeIntervalSinceDate(lastEditDate!)
            return timeSinceLastEdit > cacheAmountTimeInSeconds
        }
        return false
    }
    
    var lastBillAmount: Double{
        return defaults.doubleForKey(lastAmountKey)
    }
    
    func setTipRounding(doRound: Bool){
        defaults.setBool(doRound, forKey: alwaysRoundKey)
        defaults.synchronize()
    }
    
    func setDefaultTip(amount: Double){
        defaults.setDouble(amount, forKey: defaultTipKey)
        defaults.synchronize()
    }
    
    func setLastEditTime(time: NSDate = NSDate()){
        defaults.setObject(time, forKey: lastEditDateKey)
        defaults.synchronize()
    }
    
    func setLastBillAmount(amount: Double){
        defaults.setDouble(amount, forKey: lastAmountKey)
        defaults.synchronize()
    }
    
    func setLocale(localId: String){
        defaults.setObject(localId, forKey: localeSettingKey);
        defaults.synchronize();
    }
    
    func setTheme(theme: String){
        defaults.setObject(theme, forKey: themeSettingKey);
        defaults.synchronize();
    }
    
    func clearValues(){
        setLastBillAmount(0)
    }

}