import WHCCareKit_iOS

class CarddataManager {
    private let bluetoothManager = CareBluetoothManager()
    private var taskManager: CareTaskManager?

    init() {
        bluetoothManager.delegate = self
    }

    func loadVSD() {
        bluetoothManager.connectToDevice(deviceIndex: 0)
                taskManager?.loadVSD()
    }

    func loadNFD() {
        taskManager?.loadNFD(targetEnvironment: HealthDeviceTargetEnvironment.productive, emergencyIndicator: false, updateIndicator: false)
    }

    func loadDPE() {
        taskManager?.loadDPE(targetEnvironment: HealthDeviceTargetEnvironment.productive, emergencyIndicator: false, updateIndicator: false)
    }

    func loadAMTS() {
        taskManager?.loadAMTS(targetEnvironment: HealthDeviceTargetEnvironment.productive)
    }

    func cleanupAndDisconnect() {
        taskManager?.cleanup(completion: {
            self.bluetoothManager.disconnectFromDevice()
        })
    }
}

extension CarddataManager: CareBluetoothManagerDelegate {
    func careBluetoothManager(didUpdateState state: CareBluetoothManagerStates) {
        print("careBluetoothManager didUpdateState> \(state)")
    }

    func careBluetoothManager(didThrowMessage message: CareBluetoothManagerMessages) {
        print("careBluetoothManager didThrowMessage> \(message)")
        if message == .newPeripheralDetected {}
    }

    func careBluetoothManager(didConnect ctapi: CTorgios) {
        taskManager = CareTaskManager(ctapi: ctapi, delegate: self, completion: {
            self.taskManager?.loadVSD()
        })
    }
}

extension CarddataManager: CareTaskManagerDelegate {
    func careTaskManager(didUpdateState currentAction: CareTaskManagerActions) {
        print("careTaskManager didUpdateState> \(currentAction)")
    }

    func careTaskManager(didThrowMessage message: CareTaskManagerMessages) {
        print("careTaskManager didThrowMessage> \(message)")
    }

    func careTaskManager(didLoadVSD dataset: [Data]) {
        print("careTaskManager didLoadVSD> datasets: \(dataset)")
        for data in dataset {
            print(String(decoding: data, as: UTF8.self))
        }
    }

    func careTaskManager(didLoadVSD_KVK dataset: Data) {
        print("careTaskManager didLoadVSD_KVK> datasets: \(dataset)")
        print(String(decoding: dataset, as: UTF8.self))
        taskManager?.ejectCard(slotIDs: HealthDeviceConstants.MobKT.SlotIDs.Slot1)
    }

    func careTaskManager(didLoadNFD dataset: [Data]) {
        print("careTaskManager didLoadNFD> datasets: \(dataset)")
        for data in dataset {
            print(String(decoding: data, as: UTF8.self))
        }
        taskManager?.ejectCard(slotIDs: HealthDeviceConstants.MobKT.SlotIDs.Slot1, HealthDeviceConstants.MobKT.SlotIDs.Slot2)
    }

    func careTaskManager(didLoadDPE dataset: [Data]) {
        print("careTaskManager didLoadDPE> datasets: \(dataset)")
        for data in dataset {
            print(String(decoding: data, as: UTF8.self))
        }
    }

    func careTaskManager(didLoadAMTS dataset: [Data]) {
        print("careTaskManager didLoadAMTS> datasets: \(dataset)")
        for data in dataset {
            print(String(decoding: data, as: UTF8.self))
        }
    }
}