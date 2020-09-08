import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  String username = "";
  int typedChars = 0;
  String lorem =
      "                                       Lorem ipsum dolor sit amet, consectetur adipiscing elit, eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');
  int step = 0;

  var lastTypedAt;

  void updateLastTypeAt() {
    this.lastTypedAt = new DateTime.now().millisecondsSinceEpoch;
  }

  void resetGame() {
    setState(() {
      typedChars = 0;
      step = 0;
    });
  }

  void onType(String val) {
    updateLastTypeAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(val) != 0) {
        step = 2;
      } else {
        typedChars = val.length;
      }
    });
  }

  void onUserNameType(String val) {
    setState(() {
      this.username = val.substring(0, 3);
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypeAt();
      step++;
    });

    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      //Game over
      if (step == 1 && now - lastTypedAt > 4000) {
        step++;
      }

      if (step != 1) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0)
      shownWidget = <Widget>[
        Text("Oyuna Hoşgeldin, Coronadan kaçmaya hazır mısın ? "),
        Padding(
          padding: const EdgeInsets.only(left: 36, right: 36, top: 24),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'İsmin Nerdir ?'),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: RaisedButton(
            child: Text("Oyuna Başla!"),
            onPressed: username.length == 0 ? null : onStartClick,
            textColor: Colors.white,
          ),
        )
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text('$typedChars'),
        Container(
          margin: EdgeInsets.only(left: 0),
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 90,
            startPadding: 0,
            accelerationDuration: Duration(seconds: 0),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: TextField(
            onChanged: onType,
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Type Here..'),
          ),
        ),
      ];
    else
      shownWidget = <Widget>[
        Text("Coronaya Yakalandın, Fahrettin Koca Seni Lanetledi !"),
        Text("Skorun : $typedChars "),
        Container(
          margin: EdgeInsets.only(top: 24),
          child: RaisedButton(
            child: Text("Tekrar Dene"),
            onPressed: resetGame,
            textColor: Colors.white,
          ),
        )
      ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Klavye Delikanlısı"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: shownWidget),
      ),
    );
  }
}
