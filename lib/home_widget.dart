import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    _children = [
      Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: _todayCount.toString(),
              style: DefaultTextStyle.of(context).style.apply(fontSizeDelta: 30), //using this to change font size, but not working
              children: <TextSpan>[
              ],
            ),
          ),

          IncrementButton(incrementCounts),
        ],
      ),
      IncrementButton(incrementCounts),
      IncrementButton(incrementCounts)
    ];
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
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
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