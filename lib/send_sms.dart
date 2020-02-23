import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';
import 'package:firebase_database/firebase_database.dart';

SmsSender sender = SmsSender();
FirebaseDatabase database = FirebaseDatabase();
DatabaseReference registrees = database.reference().child('Registrees');

class SendSMS extends StatefulWidget {
  @override
  _SendSMSState createState() => _SendSMSState();
}

class _SendSMSState extends State<SendSMS> {
  bool _anchorToBottom = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: FirebaseAnimatedList(
            key: ValueKey<bool>(_anchorToBottom),
            query: registrees,
            sort: _anchorToBottom
                ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
                : null,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map<String, dynamic> dataItem = Map.from(snapshot.value);
              print(dataItem["OTP"].length);
              if (!dataItem["Sent"]) {
                SmsMessage message =
                    SmsMessage(dataItem['Number'].toString(), dataItem['OTP']);
                message.onStateChanged.listen((state) {
                  if (state == SmsMessageState.Sent) {
                    print("SMS is sent to ${dataItem['Name']}!");
                    registrees.child(snapshot.key).update({
                      "Sent": true,
                    });
                  } else if (state == SmsMessageState.Delivered) {
                    print("SMS is delivered to ${dataItem['Name']}!");
                    registrees.child(snapshot.key).update({
                      "Sent": true,
                    });
                  } else if (state == SmsMessageState.Fail) {
                    print(message.body);
                  }
                });
                sender.sendSms(message);
              }

              return SizeTransition(
                sizeFactor: animation,
                child: ListTile(
                  selected: !dataItem['Sent'],
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://api.adorable.io/avatars/285/${dataItem['Name']}',
                    ),
                  ),
                  title: Text(dataItem['Name']),
                  subtitle: Text(dataItem['Number'].toString()),
                  trailing:
                      !dataItem['Sent'] ? Text('Sending...') : Text('Sent'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
