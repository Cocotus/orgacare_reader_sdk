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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Card Data Manager'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await _orgacareDemoPlugin.loadVSD();
                },
                child: Text('Load VSD'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _orgacareDemoPlugin.loadNFD();
                },
                child: Text('Load NFD'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _orgacareDemoPlugin.loadDPE();
                },
                child: Text('Load DPE'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _orgacareDemoPlugin.loadAMTS();
                },
                child: Text('Load AMTS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}