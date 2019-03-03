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
      IncrementButton(_todayCount, incrementCounts),
      IncrementButton(_todayCount, incrementCounts),
      IncrementButton(_todayCount, incrementCounts)
    ];
  }

  int _currentIndex = 0;
  int _todayCount = 0;
  int _totalCount = 0;

  incrementCounts(){
    setState(() {
      _todayCount++;
      _totalCount++;
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
      body: _children[_currentIndex], // new
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

class PageWidget extends StatefulWidget {
  Function() incrementCounts;

  PageWidget();

  @override
  _PageWidgetState createState() => new _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new RaisedButton(onPressed: (){
          widget.incrementCounts();
        })
    );
  }
}