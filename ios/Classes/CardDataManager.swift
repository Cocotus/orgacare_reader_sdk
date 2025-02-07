import WHCCareKit_iOS
import Flutter

class CarddataManager {
    static let shared = CarddataManager()

    private let bluetoothManager = CareBluetoothManager()
    private var taskManager: CareTaskManager?
    private var channel: FlutterMethodChannel?


    func initialize(channel: FlutterMethodChannel) {
        self.channel = channel
        bluetoothManager.delegate = self
        sendLog("Initialisiere Kartenleser Plugin")

    }

@discardableResult
    func startBluetoothDiscovery() -> Bool {
        sendLog("Starte Bluetooth-Suche...")
                guard let firstDevice = bluetoothManager.discoveredPeripheralNames.first else {
                   sendLog("Kein ORGA Kartenleser gefunden...")
                    return false
                }
                 bluetoothManager.connectToDevice(deviceIndex: 0)
                 sendLog("Kartenleser verbunden: \(firstDevice)")
                return true
    }

    func loadVSD() {
        DispatchQueue.main.async {
                if self.startBluetoothDiscovery() {
                    self.sendLog("Bluetooth-Gerät verbunden und Karte wird ausgelesen...")
                } else {
                    self.sendLog("Bluetooth-Gerät konnte nicht verbunden werden.")
                }
        }
    }

    func loadNFD() {
        taskManager?.loadNFD(targetEnvironment: HealthDeviceTargetEnvironment.productive, emergencyIndicator: false, updateIndicator: false)
        sendLog("Lese NFD Daten aus....")
    }

    func loadDPE() {
        taskManager?.loadDPE(targetEnvironment: HealthDeviceTargetEnvironment.productive, emergencyIndicator: false, updateIndicator: false)
        sendLog("Lese DPE Daten aus....")
    }

    func loadAMTS() {
        taskManager?.loadAMTS(targetEnvironment: HealthDeviceTargetEnvironment.productive)
        sendLog("Lese AMTS Daten aus....")
    }

    func cleanupAndDisconnect() {
        taskManager?.cleanup(completion: {
            self.bluetoothManager.disconnectFromDevice()
            self.sendLog("Trenne Bluetooth Verbindung!")
        })
    }

    public func sendLog(_ message: String) {
        DispatchQueue.main.async {
            self.channel?.invokeMethod("log", arguments: message)
        }
    }

    public func sendDataToFlutter(_ data: [String]) {
        DispatchQueue.main.async {
            self.channel?.invokeMethod("data", arguments: data)
        }
    }

    public func notifyDeviceIsLocked() {
        DispatchQueue.main.async {
            self.channel?.invokeMethod("deviceIsLocked", arguments: nil)
        }
    }
}

extension CarddataManager: CareBluetoothManagerDelegate {
    func careBluetoothManager(didUpdateState state: CareBluetoothManagerStates) {
        let message = "careBluetoothManager Status: \(state)"
        sendLog(message)
    }

    func careBluetoothManager(didThrowMessage message: CareBluetoothManagerMessages) {
        guard let firstDevice = bluetoothManager.discoveredPeripheralNames.first else {
            sendLog("No Bluetooth devices found.")
            return
        }

        let logMessage = "Kartenleser verbunden: \(firstDevice)"
        sendLog(logMessage)
    }

    func careBluetoothManager(didConnect ctapi: CTorgios) {
        taskManager = CareTaskManager(ctapi: ctapi, delegate: self, completion: {
            self.taskManager?.loadVSD()
            self.sendLog("Karte wird ausgelesen....")
        })
    }
}

extension CarddataManager: CareTaskManagerDelegate {
    func careTaskManager(didUpdateState currentAction: CareTaskManagerActions) {
        let message = "careTaskManager Status: \(currentAction)"
        print(message)
        sendLog(message)
    }

    func careTaskManager(didThrowMessage message: CareTaskManagerMessages) {
        let logMessage = "careTaskManager Nachricht: \(message)"
        print(logMessage)
        sendLog(logMessage)
        switch message {
        case .deviceIsLocked:
            notifyDeviceIsLocked()
        default:
            break
        }
        self.cleanupAndDisconnect()
    }

    func careTaskManager(didLoadVSD dataset: [Data]) {
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.isoLatin9.rawValue))
        let isoEncoding = String.Encoding(rawValue: encoding)
        var dataStrings: [String] = []

        for dataString in dataset.dropFirst() { // Ersten Datensatz ignorieren
            if let decodedString = String(data: dataString, encoding: isoEncoding) {
                dataStrings.append(decodedString)
                var formattedString = "Sonstiges: \(decodedString)\n" // Standardmäßig "Sonstiges"
                if decodedString.contains("UC_PersoenlicheVersichertendatenXML") {
                    formattedString = "Persönliche Daten: \(decodedString)\n"
                } else if decodedString.contains("AllgemeineVersicherungsdatenXML") {
                    formattedString = "Kassendaten: \(decodedString)\n"
                }
                sendLog(decodedString)
                print(formattedString)
            } else {
                print("Fehler beim Dekodieren der Daten")
            }
        }
        sendDataToFlutter(dataStrings)
        self.cleanupAndDisconnect()
    }

    func careTaskManager(didLoadVSD_KVK dataset: Data) {
        let message = "careTaskManager KVK Versichertendaten: \(dataset)"
        print(message)
        sendLog(message)
        let dataString = String(decoding: dataset, as: UTF8.self)
        print(dataString)
        sendLog(dataString)
        taskManager?.ejectCard(slotIDs: HealthDeviceConstants.MobKT.SlotIDs.Slot1)
        sendDataToFlutter([dataString])
        self.cleanupAndDisconnect()
    }

    func careTaskManager(didLoadNFD dataset: [Data]) {
        let message = "careTaskManager NFD Daten: \(dataset)"
        print(message)
        sendLog(message)
        var dataStrings: [String] = []
        for data in dataset {
            let dataString = String(decoding: data, as: UTF8.self)
            print(dataString)
            sendLog(dataString)
            dataStrings.append(dataString)
        }
        taskManager?.ejectCard(slotIDs: HealthDeviceConstants.MobKT.SlotIDs.Slot1, HealthDeviceConstants.MobKT.SlotIDs.Slot2)
        sendDataToFlutter(dataStrings)
        self.cleanupAndDisconnect()
    }

    func careTaskManager(didLoadDPE dataset: [Data]) {
        let message = "careTaskManager DPE Daten: \(dataset)"
        print(message)
        sendLog(message)
        var dataStrings: [String] = []
        for data in dataset {
            let dataString = String(decoding: data, as: UTF8.self)
            print(dataString)
            sendLog(dataString)
            dataStrings.append(dataString)
        }
        sendDataToFlutter(dataStrings)
        self.cleanupAndDisconnect()
    }

    func careTaskManager(didLoadAMTS dataset: [Data]) {
        let message = "careTaskManager AMTS Daten: \(dataset)"
        print(message)
        sendLog(message)
        var dataStrings: [String] = []
        for data in dataset {
            let dataString = String(decoding: data, as: UTF8.self)
            print(dataString)
            sendLog(dataString)
            dataStrings.append(dataString)
        }
        sendDataToFlutter(dataStrings)
        self.cleanupAndDisconnect()
    }
}