import 'package:flutter/material.dart';
import 'home_widget.dart';
class IncrementButton extends StatefulWidget {
  Function() incrementCounts;
  int todayCounts;

  IncrementButton(this.todayCounts, this.incrementCounts);

  @override
  _IncrementButtonState createState() => new _IncrementButtonState();
}

class _IncrementButtonState extends State<IncrementButton>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        new RaisedButton(onPressed: (){
          widget.incrementCounts();
        }),
    );
  }
}