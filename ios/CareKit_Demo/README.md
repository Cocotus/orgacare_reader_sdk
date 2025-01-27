#  WHCCareKit_Demo

## Version Information

### CTorgios_Demo

  - V1.0.1 Build 2: Initial documented version
  - V1.0.2 Build 3: Dependencies updated (inlcuding new PU truststore version)
  - V1.0.3 Build 4: Dependencies updated (inlcuding optimized data reading)
  - V1.0.4 Build 5: Dependencies updated
  - V1.0.5 Build 6: Dependencies updated
  - V1.0.6 Build 7: Dependencies updated, RU/TU truststore update
  - V1.0.7 Build 8: Dependencies updated, bug fix AMTS

### CTorgmacos_Demo

  - V1.0.2 Build 3: Initial documented version
  - V1.0.3 Build 4: Dependencies updated (inlcuding new PU truststore version)
  - V1.0.4 Build 5: Dependencies updated (inlcuding optimized data reading)
  - V1.0.5 Build 6: Dependencies updated
  - V1.0.6 Build 7: Dependencies updated
  - V1.0.7 Build 8: Dependencies updated, RU/TU truststore update
  - V1.0.8 Build 9: Dependencies updated, bug fix AMTS
    
### HealthDeviceTaskManager_iOS

  - V1.0.0 Build 1: Initial version
  - V1.0.1 Build 2: CardToCard, Load Datasets, Util functions + some structural changes
  - V1.0.2 Build 3: Dependencies updated (inlcuding new PU truststore version)
  - V1.0.3 Build 4: Dependencies updated (inlcuding optimized data reading)
  - V1.0.4 Build 5: Dependencies updated
  - V1.0.5 Build 6: Dependencies updated
  - V1.0.6 Build 7: Dependencies updated, RU/TU truststore update
  - V1.0.7 Build 8: Dependencies updated, bug fix AMTS
    
### CareTaskManager_iOS

  - V1.0.0 Build 1: Initial version
  - V1.0.1 Build 2: CardToCard, Load Datasets, Util functions + some structural changes
  - V1.0.2 Build 3: Dependencies updated (inlcuding new PU truststore version)
  - V1.0.3 Build 4: Dependencies updated (inlcuding optimized data reading)
  - V1.0.4 Build 5: Dependencies updated
  - V1.0.5 Build 6: Dependencies updated
  - V1.0.6 Build 7: Dependencies updated, RU/TU truststore update
  - V1.0.7 Build 8: Dependencies updated, bug fix AMTS
    
### CareTaskManager_macOS

  - V1.0.0 Build 1: Initial version
  - V1.0.1 Build 2: CardToCard, Load Datasets, Util functions + some structural changes
  - V1.0.2 Build 3: Dependencies updated (inlcuding new PU truststore version)
  - V1.0.3 Build 4: Dependencies updated (inlcuding optimized data reading)
  - V1.0.4 Build 5: Dependencies updated
  - V1.0.5 Build 6: Dependencies updated
  - V1.0.6 Build 7: Dependencies updated, RU/TU truststore update
  - V1.0.7 Build 8: Dependencies updated, bug fix AMTS
  
## Introduction to WHCCareKit

WHCCareKit is a framework that includes tools that can be used to communicate with an ORGA 930 care device.
This framework is developed in Swift for iOS and macOS.

### CTorgios and CTorgmacos class

  These classes are the part of a low level CTAPI (Card Terminal API). Both classe can be initialized for a Blootooth Low Energy (BLE) connection. 
  The macOS version can also be initialized for a serial port connection.
  
  For using with BLE connection it is neccessary to connect to a Care device by using CoreBluetooth. The connected CBPeripheral can be used to initialize the CTAPI. The communication setup is managed outside of the CTAPI.
  
  For using the serial port connection for macOS it is neccessary to initialize the CTAPI with a string refering to the serial port that is connected to the Care. The communication setup is managed by the CTAPI.
  
  The CTAPI provides some low level functions like CTDEORGT1_init, CTDEORGT1_data and CTDEORGT1_close to communicate with a ORGA 930 care device.
  
  For more informations se examples CareKit_CTorgios and CareKit_CTorgmacos.

### HealthDeviceTaskManager class

  This class is a manager for executing tasks for the ORGA 930 care. 
  
  It can be initialized with a CTAPI instance, that is used for communication.
  
  Once the HealthDeviceTaskManager is initialized it is possible to define a task pool that can be filled with pre-built tasks.
  There are pre-built tasks for eGKs, KVKs, HBAs, SMCBs and Card terminals like the ORGA 930 care. These tasks can be called to for example receive data from the card or insert/eject cards.
  
  If the task pool is filled it it possible to runn these by a simple command.
  
  For more informations se examples HealthDeviceTaskManager_iOS.
  
### CareTaskManager class

  This class can be initialize with a CTAPI and is a high level manager. Currently if support full automatic reading of Health Card data.
  It automatically detects the operation mode of the Care (mobile or stationary) and returns the data of the card (eGK or KVK).
  Its an easy way to communicate with Care devices but.
  
  For more informations se examples CareTaskManager_iOS.

### CareBluetoothManager and CareSerialManager

  These classes can be used to simply connect to an ORGA 930 care device.
  
  The bluetooth manager can be used on iOS and macOS to establish a Bluetooth Low Energy connection.
  
  The serial port manager can be used only on macOS to establish a serial port connection.
  
  Both classes will return a CTAPI object after the connection is established that can be used to intialize for example the CareTaskManager.
  
  This is an easy way to connect to a Care device.
  
    For more informations see examples like CareTaskManager_iOS

## Demos in this project

- CTorgios_Demo

- CTorgmacos_Demo

- HealthDeviceTaskManager_iOS

- CareTaskManager_iOS

- CareTaskManager_macOS

For more information see README files for the target
