import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orgacare_reader_sdk/orgacare_reader_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _feedback = 'No feedback yet';
  final _orgacareDemoPlugin = OrgacareReaderSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _orgacareDemoPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Method to handle feedback updates
  Future<void> _updateFeedback(String methodName, Future<String> Function() method) async {
    try {
      final result = await method();
      setState(() {
        _feedback = '$methodName: $result';
      });
    } catch (e) {
      setState(() {
        _feedback = '$methodName failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Card Data Manager'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Platform Version: $_platformVersion\n'),
              Text('Feedback: $_feedback\n'),
              ElevatedButton(
                onPressed: () => _updateFeedback('Load VSD', () async {
                  final result = await _orgacareDemoPlugin.loadVSD();
                  return result ?? 'No result';
                }),
                child: const Text('Load VSD'),
              ),
              ElevatedButton(
                onPressed: () => _updateFeedback('Load NFD', () async {
                  final result = await _orgacareDemoPlugin.loadNFD();
                  return result ?? 'No result';
                }),
                child: const Text('Load NFD'),
              ),
              ElevatedButton(
                onPressed: () => _updateFeedback('Load DPE', () async {
                  final result = await _orgacareDemoPlugin.loadDPE();
                  return result ?? 'No result';
                }),
                child: const Text('Load DPE'),
              ),
              ElevatedButton(
                onPressed: () => _updateFeedback('Load AMTS', () async {
                  final result = await _orgacareDemoPlugin.loadAMTS();
                  return result ?? 'No result';
                }),
                child: const Text('Load AMTS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}