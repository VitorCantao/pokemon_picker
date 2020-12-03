import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String _text;

  const MessageDisplay({
    Key key,
    @required String text,
  })  : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: Text(
          _text,
          style: TextStyle(fontSize: 26),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
