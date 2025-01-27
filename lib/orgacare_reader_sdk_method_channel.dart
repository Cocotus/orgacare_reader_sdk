import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'orgacare_reader_sdk_platform_interface.dart';

/// An implementation of [OrgacareReaderSdkPlatform] that uses method channels.
class MethodChannelOrgacareReaderSdk extends OrgacareReaderSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('orgacare_reader_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
