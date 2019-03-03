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
    var scanSubscription = flutterBlue.scan().listen((scanResult) async {
      print(scanResult.advertisementData.localName);
      print(scanResult.advertisementData.serviceData);
      print("@@@@@@@@@@@@@@@@@@@@@@@@@");
      if(scanResult.advertisementData.localName== 'ItsTime'){
          var deviceConnection = flutterBlue.connect(scanResult.device).listen((s) async {
            if(s == BluetoothDeviceState.connected) {
              List<BluetoothService> services = await scanResult.device.discoverServices();
              services.forEach((service) async {
                for(BluetoothCharacteristic c in service.characteristics) {
                  if (c.uuid == new Guid("88888888-4444-4444-4444-ccccccccccc1")) {
                    await scanResult.device.setNotifyValue(c, true);
                    scanResult.device.onValueChanged(c).listen((value) {
                      incrementCounts();
                    });
                  }
                }
              });
            }
          });
          deviceConnection.cancel();
        }
    });


    scanSubscription.cancel();
  }

  int _currentIndex = 0;
  int _todayCount = 0;
  int _totalCount = 0;

  incrementCounts(){
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
}