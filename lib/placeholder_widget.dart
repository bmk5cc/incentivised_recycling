import 'package:flutter/material.dart';
import 'home_widget.dart';
class PlaceholderWidget extends StatefulWidget {
  final Color color;
  Function() incrementCounts;

  PlaceholderWidget(this.color, this.incrementCounts);

  @override
  _PlaceholderWidgetState createState() => new _PlaceholderWidgetState();
}

class _PlaceholderWidgetState extends State<PlaceholderWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: new RaisedButton(onPressed: (){
        widget.incrementCounts();
      })
    );
  }
}