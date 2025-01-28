import 'package:flutter/material.dart';
import 'package:orgacare_reader_sdk/card_data_manager.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CardDataManager _cardDataManager = CardDataManager();

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
                  await _cardDataManager.loadVSD();
                },
                child: Text('Load VSD'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _cardDataManager.loadNFD();
                },
                child: Text('Load NFD'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _cardDataManager.loadDPE();
                },
                child: Text('Load DPE'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _cardDataManager.loadAMTS();
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