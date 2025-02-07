import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orgacare_reader_sdk/orgacare_reader_sdk.dart';
import 'package:xml/xml.dart';

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
    }
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {

      String xmlString = '''<?xml version="1.0" encoding="ISO-8859-15" standalone="yes"?>
  <UC_PersoenlicheVersichertendatenXML CDM_VERSION="5.2.0" xmlns="http://ws.gematik.de/fa/vsdm/vsd/v5.2">
    <Versicherter>
      <Versicherten_ID>V929324877</Versicherten_ID>
      <Person>
        <Geburtsdatum>19831001</Geburtsdatum>
        <Vorname>Peter</Vorname>
        <Nachname>Müller</Nachname>
        <Geschlecht>M</Geschlecht>
        <StrassenAdresse>
          <Postleitzahl>49716</Postleitzahl>
          <Ort>Meppen</Ort>
          <Land>
            <Wohnsitzlaendercode>D</Wohnsitzlaendercode>
          </Land>
          <Strasse>Uhlandstr.</Strasse>
          <Hausnummer>12</Hausnummer>
        </StrassenAdresse>
      </Person>
    </Versicherter>
  </UC_PersoenlicheVersichertendatenXML>''';

      // Parse the XML
      final document = XmlDocument.parse(xmlString);

      // Extract specific values
      final geburtsdatum = document.findAllElements('Geburtsdatum').first.innerText;
      final vorname = document.findAllElements('Vorname').first.innerText;
      final nachname = document.findAllElements('Nachname').first.innerText;
      final geschlecht = document.findAllElements('Geschlecht').first.innerText;
      final ort = document.findAllElements('Ort').first.innerText;

      // Print extracted values
      print("Geburtsdatum: $geburtsdatum"); // 19831001
      print("Vorname: $vorname"); // Peter
      print("Nachname: $nachname"); // Müller
      print("Geschlecht: $geschlecht"); // M
      print("Ort: $ort"); // Meppen

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
            ],
          ),
        ),
      ),
    );
  }
}