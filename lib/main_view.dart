import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:otpapp/send_sms.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pursat SMS"),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Dark Theme'),
              trailing: Switch(
                onChanged: (bool value) {
                  DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark,
                  );
                },
                value: Theme.of(context).brightness == Brightness.dark
                    ? true
                    : false,
              ),
            ),
            Divider(),
          ],
        ),
      ),
      body: SendSMS(),
    );
  }
}
