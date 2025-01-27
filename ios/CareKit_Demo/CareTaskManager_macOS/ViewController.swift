//
//  ViewController.swift
//  CareTaskManager_macOS
//
//  Copyright (C) Worldline Healthcare GmbH
//
//  Main view controller for this demo.
//
//  • Created by Worldline Healthcare GmbH; tpe on 08.12.2021.
//

import Cocoa
import WHCCareKit_macOS

class ViewController: NSViewController {
  
  /// Care serial manager instance
  private var serialManager = CareSerialManager()

  /// Care task manager instance
  private var taskManager: CareTaskManager?
  
  /// PopUpButton for listing all detected devices
  @IBOutlet weak var devicePopUpButton: NSPopUpButton!
  
  @IBAction func connectButtonAction(_ sender: NSButton) {
    
    if let port = devicePopUpButton.selectedItem?.title {
    
      serialManager.connectToDevice(serialPortPath: port)
    
    }
    
  }
  
  @IBAction func loadVSDButtonAction(_ sender: NSButton) {
    
    taskManager?.loadVSD()
    
  }
  
  @IBAction func loadNFDButtonAction(_ sender: NSButton) {
    
    taskManager?.loadNFD(targetEnvironment: .test, emergencyIndicator: true, updateIndicator: false)
    
  }
  
  @IBAction func disconnectButtonAction(_ sender: Any) {
    
    serialManager.disconnectFromDevice()
    
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // MARK:  Declare the current view controller as delegate for the serial manager.
    //        This allows the current view controller to receive information from the
    //        serial manager by implementing the protocol methodes.
    serialManager.delegate = self
    
    // Update the popup device button with vailable serial ports
    updateDevicePopUpButton()
    
  }
  
}

extension ViewController {
  
  private func updateDevicePopUpButton() {
    
    // To show all available ports in the popup button the
    // availableSerialPortPaths property of the serial manager can be used.
    
    devicePopUpButton.removeAllItems()
    
    devicePopUpButton.addItems(withTitles: serialManager.availableSerialPortPaths)
    
  }
  
}

// MARK: - Implementation of the CareSerialManagerDelegate methodes

extension ViewController: CareSerialManagerDelegate {
  
  func careSerialManager(didUpdateState state: CareSerialManagerStates) {
    
    // MARK:  Receives the state of the serial manager
    //
    //        When the state of the connection changes this method will be called.
    //
    //        For example:  The state can be used to check if the serial manager is
    //                      currently connected or in standby.
    //
    //        All states are listed in the Xcode documentation for CareSerialManagerStates.
    
    // In this example the state is simply printed out to the terminal.
    
    print("careSerialManager didUpdateState> \(state)")
    
  }
  
  func careSerialManager(didThrowMessage message: CareSerialManagerMessages) {
    
    // MARK:  Receives a message from the serial manager
    //
    //        With this method the serial manager can inform about message events.
    //
    //        For example:  The messages can be used to check for example if a connection error
    //                      or connection timeout has occured.
    //
    //        All states are listed in the Xcode documentation for CareSerialManagerMessages.
    
    // In this example the message is simply printed out to the terminal.
    
    print("careSerialManager didThrowMessage> \(message)")
    
  }
  
  func careSerialManager(didConnect ctapi: CTorgmacos) {
    
    // MARK:  Receives the CTAPI communication instance
    //
    //        With this method the serial manager shares a CTAPI instance when the communication
    //        has been successful established.
    //
    //        The CTAPI instance can be used to initialize the Care task manager

    // In this example the task manager will be directly initialized with the receive CTAPI.
    
    // Declare the current view controller as delegate for the task manager.
    // This allows the current view controller to receive information from the
    // task manager by implementing the protocol methodes.
    // It is possible to execute some code directly after initialization was successfull by using the
    // completion block.
    
    taskManager = CareTaskManager(ctapi: ctapi, delegate: self, completion: { })
    
  }
  
}

// MARK: - Implementation of the CareTaskManagerDelegate methodes

extension ViewController: CareTaskManagerDelegate {

  func careTaskManager(didUpdateState currentAction: CareTaskManagerActions) {
    
    // MARK:  Receives the action of the task manager
    //
    //        When the action of the task manager changes this method will be called.
    //
    //        For example:  The action can be used to check the current active
    //                      step of the task manager, like:
    //                      • the Care is ask for insert or remove a card
    //                      or
    //                      • identify the active task for loading data
    //
    //        All states are listed in the Xcode documentation for CareTaskManagerActions.
    
    // In this example the state is simply printed out to the terminal.
    
    print("careTaskManager didUpdateState> \(currentAction)")
    
  }
  
  func careTaskManager(didThrowMessage message: CareTaskManagerMessages) {
    
    // MARK:  Receives a message from the bluetooth manager
    //
    //        With this method the task manager can inform about message events.
    //
    //        For example:  The messages can be used to check for example if a task error
    //                      has occured or a timeout while inserting or removing card has occured.
    //
    //        All states are listed in the Xcode documentation for CareTaskManagerMessages.
    
    // In this example the message is simply printed out to the terminal.
    
    print("careTaskManager didThrowMessage> \(message)")
    
  }

  func careTaskManager(didLoadVSD dataset: [Data]) {
    
    // MARK:  Receives data from the task manager
    //
    //        With this method the task manager can return the received VSD data.
    
    // In this example the message is simply printed out to the terminal.
   
    print("careTaskManager didLoadVSD> datasets: \(dataset)")
    
    for data in dataset {
      
      print(String(decoding: data, as: UTF8.self))
      
    }
    
  }
  
  func careTaskManager(didLoadVSD_KVK dataset: Data) {
    
    // MARK:  Receives data from the task manager
    //
    //        With this method the task manager can return the received KVK data.
    
    // In this example the message is simply printed out to the terminal.
   
    print("careTaskManager didLoadVSD_KVK> datasets: \(dataset)")

    print(String(decoding: dataset, as: UTF8.self))
    
    // Example for remove the card in slot 1 if everything was successfull
    
    taskManager?.ejectCard(slotIDs: HealthDeviceConstants.MobKT.SlotIDs.Slot1)
    
  }
  
  func careTaskManager(didLoadNFD dataset: [Data]) {
    
    // MARK:  Receives data from the task manager
    //
    //        With this method the task manager can return the received NFD data.
    
    // In this example the message is simply printed out to the terminal.
   
    print("careTaskManager didLoadNFD> datasets: \(dataset)")
    
    for data in dataset {
      
      print(String(decoding: data, as: UTF8.self))
      
    }
    
    // Example for remove the card in slot 1 and slot 2 if everything was successfull
    
    taskManager?.ejectCard(slotIDs: HealthDeviceConstants.MobKT.SlotIDs.Slot1, HealthDeviceConstants.MobKT.SlotIDs.Slot2)
    
  }
  
  func careTaskManager(didLoadDPE dataset: [Data]) {
    
    // Not implemented in this example
    
  }
  
  func careTaskManager(didLoadAMTS dataset: [Data]) {
    
    // Not implemented in this example
    
  }
  
}
