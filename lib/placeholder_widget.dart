import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
class IncrementButton extends StatefulWidget {
  Function() incrementCounts;

  IncrementButton(this.incrementCounts);

  @override
  _IncrementButtonState createState() => new _IncrementButtonState();
}

class _IncrementButtonState extends State<IncrementButton>{



  @override
  Widget build(BuildContext context) {


    return Container(
      child:
        new RaisedButton(
            onPressed: (){
              widget.incrementCounts();
            },
            child: const Text("I Recycled!"),
        ),
    );
  }
}