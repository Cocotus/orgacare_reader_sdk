import 'package:flutter/services.dart';

class CardDataManager {
  static const MethodChannel _channel = MethodChannel('card_data_manager');

  Future<void> loadVSD() async {
    await _channel.invokeMethod('loadVSD');
  }

  Future<void> loadNFD() async {
    await _channel.invokeMethod('loadNFD');
  }

  Future<void> loadDPE() async {
    await _channel.invokeMethod('loadDPE');
  }

  Future<void> loadAMTS() async {
    await _channel.invokeMethod('loadAMTS');
  }
}