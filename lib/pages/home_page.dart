import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../services/link_service.dart';
import '../services/log_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  static const String id = "home_page";

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  String deeplink = "no link";

  final remoteConfig = FirebaseRemoteConfig.instance;
  final Map<String, dynamic> availableBackgroundColors = {
    "red": Colors.red,
    "yellow": Colors.yellow,
    "blue": Colors.blue,
    "green": Colors.green,
    "white": Colors.white
  };
  String backgroundColor = "white";

  @override
  void initState() {
    super.initState();
    LinkService.retrieveDynamicLink().then((value) => {
          setState(() {
            if (value != null) {
              deeplink = value.toString();
              // need to save data locally...
            } else {
              deeplink = "No Link";
            }
          })
        });
    //LinkService.createShortLink("200002");
    initConfig();
  }

  /// Remote Config Functions
  void initConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 10), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
              10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    await remoteConfig.setDefaults(const {
      "background_color": "white",
    });
    fetchConfig();
  }

  void fetchConfig() async {
    await remoteConfig.fetchAndActivate().then((value) => {
          setState(() {
            backgroundColor =
                remoteConfig.getString('background_color').isNotEmpty
                    ? remoteConfig.getString('background_color')
                    : "white";
          }),
          LogService.d(value.toString())
        });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      //FirebaseCrashlytics.instance.crash();
      //LinkService.createShortLink("200002");
      //LinkService.createLongLink("100001");
      fetchConfig();
    });
    //var str1 = reverse("pdp academy");
    //var str2 = reverse("pdp university");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: availableBackgroundColors[backgroundColor],
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              deeplink,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
