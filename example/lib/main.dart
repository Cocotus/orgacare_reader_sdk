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
  static const platform = MethodChannel('orgacare_reader_sdk');
  List<String> _logs = [];
  List<String> _data = [];
  bool _isDeviceLocked = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    platform.setMethodCallHandler(_handleMethodCall);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'log':
        setState(() {
          _logs.add(call.arguments);
        });
        break;
      case 'data':
        setState(() {
          _data = List<String>.from(call.arguments);
        });
        break;
      case 'deviceIsLocked':
        setState(() {
          _isDeviceLocked = true;
        });
        break;
    }
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _orgacareDemoPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

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
              _isDeviceLocked
                  ? Text('Device is locked', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                  : Container(),
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
              Expanded(
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_logs[index]),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_data[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}