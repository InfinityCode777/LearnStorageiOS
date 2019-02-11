//
//  ExtString.swift
//  loggerApp
//
//  Created by Jing Wang on 1/22/19.
//  Copyright © 2019 figur8. All rights reserved.
//
import Foundation

public enum F8LocaleStrings: String, F8Localizable, CaseIterable {
    // For info page
    case otherActivity
    case otherTrainee
    case continueNext
    case doneText
    
    
    // F8RecorderVC.swift
    case testNamePlaceholder
    case notesNamePlaceholder
    case noDeviceConnected
    case trialsText
    case startCollectingData
    case magDeclinationNote
    case plotLengendNotApply
    case plotLengendNotAssign
    
    case alertSavedError
    case alertOK
    case alertSavedOk
    case alertPhotoSavedToAlbum
    case alertSave
    case alertInputMagIncl
    case alertInputHeading
    case alertCollectAngle
    case figur8
    case alertDelete
    case inputNameAlertTitle
    
    // F8Device or similar
    case photoAudioNotAuthorized
    case deviceDisconnected
    
    // Generic format
    
    
    public var tableName: String {
        return "Localizable"
    }
    
    public var tableBundle: Bundle {
        return Bundle.main
    }
}
