// ios/Classes/Swift/CardDataManager.swift
import Foundation
import WHCCareKit_iOS

class CardDataManager {
    private var taskManager: CareTaskManager?
    
    init() {
        // Initialize the task manager and other necessary components here
    }
    
    func createPoolForLoadVSD() {
        // Your implementation for createPoolForLoadVSD
    }
    
    func loadVSD() {
        // Your implementation for loadVSD
        taskManager?.loadVSD()
    }
    
    func loadNFD() {
        // Your implementation for loadNFD
        taskManager?.loadNFD(targetEnvironment: .test, emergencyIndicator: true, updateIndicator: false)
    }
    
    func loadDPE() {
        // Your implementation for loadDPE
        taskManager?.loadDPE(targetEnvironment: .test, emergencyIndicator: true, updateIndicator: false)
    }
    
    func loadAMTS() {
        // Your implementation for loadAMTS
        taskManager?.loadAMTS(targetEnvironment: .test)
    }
}