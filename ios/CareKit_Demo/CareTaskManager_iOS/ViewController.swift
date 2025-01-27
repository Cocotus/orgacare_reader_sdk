//
//  ViewController.swift
//  CareTaskManager_iOS
//
//  Copyright (C) Worldline Healthcare GmbH
//
//  Main view controller for this demo.
//
//  • Created by Worldline Healthcare GmbH; tpe on 30.11.2021.
//

import UIKit
import WHCCareKit_iOS

class ViewController: UIViewController {

  /// Care bluetooth manager instance
  private let bluetoothManager = CareBluetoothManager()
  
  /// Care task manager instance
  private var taskManager: CareTaskManager?
  
  /// PickerView for listing all detected devices
  @IBOutlet weak var devicePickerView: UIPickerView!
  
  @IBAction func connectButtonAction(_ sender: UIButton) {
    
    // MARK:  Connect to the Care
    
    // Simply connect to the selected device index in the picker view
    bluetoothManager.connectToDevice(deviceIndex: devicePickerView.selectedRow(inComponent: 0))
    
  }
  
  @IBAction func loadVSDButtonAction(_ sender: UIButton) {
    
    // MARK:  Load VSD from the Care
    
    taskManager?.loadVSD()
    
    // Alternative call
    
    //taskManager?.loadVSD(targetEnvironment: .test)
    
  }
  
  @IBAction func loadNFDButtonAction(_ sender: UIButton) {
    
    // MARK:  Load NFD from the Care
    
    // Here the test environment has been selected.
    taskManager?.loadNFD(targetEnvironment: .test, emergencyIndicator: true, updateIndicator: false)
    
  }
  
  @IBAction func loadDPEButtonAction(_ sender: UIButton) {
    
    // MARK:  Load DPE from the Care
    
    // Here the test environment has been selected.
    taskManager?.loadDPE(targetEnvironment: .test, emergencyIndicator: true, updateIndicator: false)
    
  }
  
  @IBAction func loadAMTSButtonAction(_ sender: UIButton) {
    
    // MARK:  Load AMTS from the Care
    
    // Here the test environment has been selected.
    taskManager?.loadAMTS(targetEnvironment: .test)
    
  }
  
  @IBAction func disconnectButtonAction(_ sender: UIButton) {
    
    // MARK:  Cleanup and disconnect from the Care
    
    // Simply run the cleanup method of the task manager.
    taskManager?.cleanup(completion: {
      
      // If the cleanup is finished the disconnect method of the
      // bluetooth  manager can be called.
      self.bluetoothManager.disconnectFromDevice()
    
    })
    
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    // MARK:  Declare the current view controller as delegate for the bluetooth manager.
    //        This allows the current view controller to receive information from the
    //        bluetooth manager by implementing the protocol methodes.
    bluetoothManager.delegate = self
    
    // Setup the current view controller as delegate and data source for the device picker view
    devicePickerView.delegate = self
    devicePickerView.dataSource = self
    
  }
  
}

// MARK: - Implementation of the CareBluetoothManagerDelegate methodes

extension ViewController: CareBluetoothManagerDelegate {
  
  func careBluetoothManager(didUpdateState state: CareBluetoothManagerStates) {
    
    // MARK:  Receives the state of the bluetooth manager
    //
    //        When the state of the connection changes this method will be called.
    //
    //        For example:  The state can be used to check if the bluetooth manager is
    //                      currently connected or scanning.
    //
    //        All states are listed in the Xcode documentation for CareBluetoothManagerStates.
    
    // In this example the state is simply printed out to the terminal.
    
    print("careBluetoothManager didUpdateState> \(state)")
    
  }
  
  func careBluetoothManager(didThrowMessage message: CareBluetoothManagerMessages) {
    
    // MARK:  Receives a message from the bluetooth manager
    //
    //        With this method the bluetooth manager can inform about message events.
    //
    //        For example:  The messages can be used to check for example if a connection error
    //                      has occured or a new peripheral has been detected.
    //
    //        All states are listed in the Xcode documentation for CareBluetoothManagerMessages.
    
    // In this example the message is used to check for new detected peripherals.
    // If a peripheral has been detected the picker view will be triggered for
    // updating its components.
    
    print("careBluetoothManager didThrowMessage> \(message)")
    
    switch message {

    case .newPeripheralDetected: devicePickerView.reloadAllComponents()

    default: break
      
    }
    
  }
  
  func careBluetoothManager(didConnect ctapi: CTorgios) {
    
    // MARK:  Receives the CTAPI communication instance
    //
    //        With this method the bluetooth manager shares a CTAPI instance when the communication
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
    
    // MARK:  Receives a message from the task manager
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
    
    // MARK:  Receives data from the task manager
    //
    //        With this method the task manager can return the received DPE data.
    
    // In this example the message is simply printed out to the terminal.
   
    print("careTaskManager didLoadDPE> datasets: \(dataset)")
    
    for data in dataset {
      
      print(String(decoding: data, as: UTF8.self))
      
    }
    
  }
  
  func careTaskManager(didLoadAMTS dataset: [Data]) {
    
    // MARK:  Receives data from the task manager
    //
    //        With this method the task manager can return the received AMTS data.
    
    // In this example the message is simply printed out to the terminal.
   
    print("careTaskManager didLoadAMTS> datasets: \(dataset)")
    
    for data in dataset {
      
      print(String(decoding: data, as: UTF8.self))
      
    }
    
  }
  
}

// MARK: - Implementation of the UIPickerViewDelegate methodes

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
 
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    // To prepare the number of rows in the picker view the count of the discoveredPeripheralNames property
    // of the bluetooth manager can be used.
    
    return bluetoothManager.discoveredPeripheralNames.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    // To show all discovered devices in the picker view the discoveredPeripheralNames property
    // of the bluetooth manager can be used.
    
    return bluetoothManager.discoveredPeripheralNames[row]
  }
  
}
