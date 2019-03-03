import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'placeholder_widget.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home> {

  FlutterBlue flutterBlue;
  StreamSubscription scanSubscription;
  BluetoothDevice device;
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  List<BluetoothService> services = new List();


  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    _children = [
      Column(
        children: <Widget>[
          Text(_todayCount.toString()),
          IncrementButton(incrementCounts),
        ],
      ),
      IncrementButton(incrementCounts),
      IncrementButton(incrementCounts)
    ];


    flutterBlue = FlutterBlue.instance;

    scanSubscription =
        flutterBlue.scan(timeout: const Duration(seconds: 4),).listen((scanResult) async {
          setState(() {
            scanResults[scanResult.device.id] = scanResult;
          });
        }, onDone: _stopScan);

    print('@@@@@@@@@@@@@@@@2');
    scanResults.values.forEach((scanResult) {
      print(scanResult.device.name);
      print(scanResult.device.id);
      if(scanResult.device.name == 'ItsTime'){
        flutterBlue
            .connect(device, timeout: const Duration(seconds: 4))
            .listen(
          null,
          onDone: _disconnect,
        );

        // Update the connection state immediately
        device.state.then((s) {
          setState(() {
            deviceState = s;
          });
        });

      }

      // Subscribe to connection changes
      deviceStateSubscription = device.onStateChanged().listen((s) {
        setState(() {
          deviceState = s;
        });
        if (s == BluetoothDeviceState.connected) {
          device.discoverServices().then((s) {
            setState(() {
              services = s;
            });
          });
        }
      });
    });

    services.map((s) {
      s.characteristics.forEach((c) async {
        if(s.uuid == Guid("88888888-4444-4444-4444-CCCCCCCCCCC1")){
          await device.setNotifyValue(c, true);
          device.onValueChanged(c).listen((value) {
            incrementCounts();
          });
        }
      });
    });
  }

  int _currentIndex = 0;
  int _todayCount = 0;
  int _totalCount = 0;

  incrementCounts() {
    setState(() {
      _todayCount++;
      _totalCount++;

      _children = [
        Column(
          children: <Widget>[
            Text(_todayCount.toString()),
            IncrementButton(incrementCounts),
          ],
        ),
        IncrementButton(incrementCounts),
        IncrementButton(incrementCounts)
      ];
    });
    print('incrementing');
    print(_todayCount);
  }

  List<Widget> _children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter App'),
      ),
      body: Center(
          child: _children[_currentIndex]
      ), // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shop),
            title: new Text('Shop'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              title: Text('Stats')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _stopScan() {
    scanSubscription?.cancel();
    scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
    setState(() {
      device = null;
    });
  }
}

//if(scanResult.advertisementData.localName== 'ItsTime'){
//var deviceConnection = flutterBlue.connect(scanResult.device).listen((s) async {
//if(s == BluetoothDeviceState.connected) {
//List<BluetoothService> services = await scanResult.device.discoverServices();
//services.forEach((service) async {
//for(BluetoothCharacteristic c in service.characteristics) {
//if (c.uuid == new Guid("88888888-4444-4444-4444-ccccccccccc1")) {
//await scanResult.device.setNotifyValue(c, true);
//scanResult.device.onValueChanged(c).listen((value) {
//incrementCounts();
//});
//}
//}
//});
//}
//});
//deviceConnection.cancel();
//}