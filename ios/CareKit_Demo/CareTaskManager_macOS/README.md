#  CareTaskManager_macOS

This example explains how to communicate with an ORGA 930 care device by using the CareTaskManager functions and the CareSerialManager.

## Introduction

This example uses the CareSerialManager for connection management and the CareTaskManager for executing tasks.

This is the easiest way to communicate with the ORGA 930 care. Everything is implemented in the "ViewController.swift".

This example is for macOS.

## Description

Everything that is needed for receiving data from the Care by using the "WHCCareKit_macOS" framework has been placed in the ViewController.siwft.

There can be find source code comments and source code marks that will describe the usage and functionality of the framework.

There is a minimalistic user interface with a popup button for selecting a Care that will be provided by the the serial manager.

The connect button will connect the currently selected device in the picker view.

The disconnect button will cleanup and disconnect the currently connected device.

The load data button will simply start the load data task of the task manager.

The current actions, activities, states and event the received data are all printed out in the terminal.

### Addon in Version 1.0.1

* The Load NFD Button will start reading the data from the eGK. Therfor a card to card will be performed automatically if needed.

* For now the removing of cards needs to be called manually. The Load VSD / NFD examples are showing how to remove a card.
