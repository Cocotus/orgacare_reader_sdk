
import 'orgacare_reader_sdk_platform_interface.dart';

class OrgacareReaderSdk {
  Future<String?> getPlatformVersion() {
    return OrgacareReaderSdkPlatform.instance.getPlatformVersion();
  }
}
