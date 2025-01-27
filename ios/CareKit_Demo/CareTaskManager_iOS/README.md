#  CareTaskManager_iOS

This example explains how to communicate with an ORGA 930 care device by using the CareTaskManager functions and the CareBluetoothManager.

## Introduction

This example uses the CareBluetoothManager for connection management and the CareTaskManager for executing tasks.

This is the easiest way to communicate with the ORGA 930 care. Everything is implemented in the "ViewController.swift".

This example is for iOS / iPadOS but can also be built for macCatalyst.

For macOS the usage of the classes is the same like in this built target. But macOS supports the CareSerialManager for serial connection.

## Description

Everything that is needed for receiving data from the Care by using the "WHCCareKit_iOS" framework has been placed in the ViewController.siwft.

There can be find source code comments and source code marks that will describe the usage and functionality of the framework.

There is a minimalistic user interface with a picker view for selecting a Care that will be discoverded by the the bluetooth manager.

The connect button will connect the currently selected device in the picker view.

The disconnect button will cleanup and disconnect the currently connected device.

The load VSD data button will simply start the load data task of the task manager.

The current actions, activities, states and event the received data are all printed out in the terminal.

### Addon in Version 1.0.1

* The Load NFD / DPE / AMTS Button will start reading the data from the eGK. Therfor a card to card will be performed automatically if needed.

* For now the removing of cards needs to be called manually. The Load VSD / NFD examples are showing how to remove a card.
