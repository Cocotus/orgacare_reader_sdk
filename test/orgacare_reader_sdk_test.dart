import 'package:flutter_test/flutter_test.dart';
import 'package:orgacare_reader_sdk/orgacare_reader_sdk.dart';
import 'package:orgacare_reader_sdk/orgacare_reader_sdk_platform_interface.dart';
import 'package:orgacare_reader_sdk/orgacare_reader_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOrgacareReaderSdkPlatform
    with MockPlatformInterfaceMixin
    implements OrgacareReaderSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final OrgacareReaderSdkPlatform initialPlatform = OrgacareReaderSdkPlatform.instance;

  test('$MethodChannelOrgacareReaderSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOrgacareReaderSdk>());
  });

  test('getPlatformVersion', () async {
    OrgacareReaderSdk orgacareReaderSdkPlugin = OrgacareReaderSdk();
    MockOrgacareReaderSdkPlatform fakePlatform = MockOrgacareReaderSdkPlatform();
    OrgacareReaderSdkPlatform.instance = fakePlatform;

    expect(await orgacareReaderSdkPlugin.getPlatformVersion(), '42');
  });
}
