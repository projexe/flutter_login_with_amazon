import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_login_with_amazon/flutter_login_with_amazon.dart';

const _scopes = {
  'profile': null,
  'alexa:all': {
    'productID': 'YOURPRODUCTID',
    'productInstanceAttributes': {
      'deviceSerialNumber': 'serialNumberHere',
    },
  },
  'dash:replenish': {
    'device_model': 'YOURDEVICEMODEL',
    'serial': 'serialNumberHere',
    'is_test_device': true
  },
};

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
  final _flutterLoginWithAmazonPlugin = FlutterLoginWithAmazon();

  List<Widget> _authRespose = [];
  String _logResult = '';
  String _result = '';
  String _codeChallengeMethod = 'plain';
  final _alexaId = TextEditingController(text: 'YOURPRODUCTID');
  final _dashModel = TextEditingController(text: 'YOURDEVICEMODEL');
  final _serialNumber = TextEditingController(text: 'someSerialNeeded');
  final _codeChallenge = TextEditingController(
      text: 'code_generated_by_the_dash_device_for_LWA_verification');
  final FlutterLoginWithAmazon lwa = FlutterLoginWithAmazon();

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
          await _flutterLoginWithAmazonPlugin.getPlatformVersion() ??
              'Unknown platform version';
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
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _alexaId,
                decoration: const InputDecoration(
                  labelText: 'Alexa Product Id',
                ),
              ),
              TextFormField(
                controller: _dashModel,
                decoration: const InputDecoration(
                  labelText: 'Dash Model',
                ),
              ),
              TextFormField(
                controller: _serialNumber,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                ),
              ),
              TextFormField(
                controller: _codeChallenge,
                decoration: const InputDecoration(
                  labelText: 'Code Challenge',
                ),
              ),
              DropdownButtonFormField(
                  onChanged: (val) {
                    setState(() {
                      _codeChallengeMethod = val ?? '';
                    });
                  },
                  value: _codeChallengeMethod,
                  items: ['plain', 'S256']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList()),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final result = await lwa.login({
                      'profile': null,
                    });
                    if (result != null) {
                      _result = result.entries
                          .map((entry) => "${entry.key}: ${entry.value}")
                          .reduce((str, str2) => "$str, \n $str2");
                      setState(() {
                        _logResult = result.containsKey("accessToken")
                            ? "Logged In"
                            : "Cancelled";
                        _authRespose = result.entries.map((entry) {
                          return Text("${entry.key}: ${entry.value}");
                        }).toList();
                      });
                    }
                  } catch (e) {
                    setState(() {
                      _logResult = "failed";
                    });
                  }
                },
                child: const Text("Login"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await lwa.getAuthCode(
                    _codeChallenge.text,
                    "plain",
                    {
                      'profile': null,
                      'dash:replenish': {
                        'device_model': _dashModel.text,
                        'serial': _serialNumber.text,
                        'is_test_device': true
                      },
                    },
                  );
                  if (result != null) {
                    _result = result.entries
                        .map((entry) => "${entry.key}: ${entry.value}")
                        .reduce((str, str2) => "$str, \n $str2");
                    setState(() {
                      _authRespose = result.entries.map((entry) {
                        return Text("${entry.key}: ${entry.value}");
                      }).toList();
                    });
                  }
                },
                child: const Text("Get Dash Auth Code"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await lwa.getAuthCode(
                    "code_generated_by_the_dash_device_for_LWA_verification",
                    "plain",
                    {
                      'profile': null,
                      'alexa:all': {
                        'productID': _alexaId.text,
                        'productInstanceAttributes': {
                          'deviceSerialNumber': _serialNumber.text,
                        },
                      }
                    },
                  );
                  if (result != null ) {
                    _result = result.entries
                        .map((entry) => "${entry.key}: ${entry.value}")
                        .reduce((str, str2) => "$str, \n $str2");
                    setState(() {
                      _authRespose = result.entries.map((entry) {
                        return Text("${entry.key}: ${entry.value}");
                      }).toList();
                    });
                  }
                },
                child: const Text("Get Alexa Auth Code"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await lwa.getAccessToken(_scopes);
                  setState(() {
                    _authRespose = [Text('AccessToken: $result')];
                    _result = result ?? 'Result returned null';
                  });
                },
                child: const Text("Get Access Token"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await lwa.logout();
                  setState(() {
                    _logResult = 'Logged Out';
                    _result = '';
                  });
                },
                child: const Text("Logout"),
              ),
              Text('LogResult: $_logResult'),
              ..._authRespose,
              ElevatedButton(
                onPressed: () async {
                  Clipboard.setData(ClipboardData(text: _result));
                },
                child: const Text("Copy To Clipboard"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
