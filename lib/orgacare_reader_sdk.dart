
import 'orgacare_reader_sdk_platform_interface.dart';

class OrgacareReaderSdk {
  Future<String?> getPlatformVersion() {
    return OrgacareReaderSdkPlatform.instance.getPlatformVersion();
  }

  Future<String?> loadVSD() async {
    var result = await OrgacareReaderSdkPlatform.instance.loadVSD();
    return result;
  }

  Future<String?> loadNFD() async {
    return OrgacareReaderSdkPlatform.instance.loadNFD();
  }

  Future<String?> loadDPE() async {
    return OrgacareReaderSdkPlatform.instance.loadDPE();
  }

  Future<String?> loadAMTS() async {
    return OrgacareReaderSdkPlatform.instance.loadAMTS();
  }

}
