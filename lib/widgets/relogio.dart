import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  String _currentTime = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss').format(now);
    setState(() {
      _currentTime = formattedTime;
    });
  }

  @override
  void dispose() {
    // Certifique-se de cancelar o temporizador quando o widget for descartado
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
