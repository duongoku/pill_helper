import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:localstorage/localstorage.dart';

class ViewRemindersScreen extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('reminders.json');

  ViewRemindersScreen();

  @override
  Widget build(BuildContext context) {
    List<dynamic> reminders = storage.getItem('reminders') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('View Existing Reminders'),
      ),
      body: PageView.builder(
        itemCount: reminders.length ~/ 2 + reminders.length % 2,
        itemBuilder: (context, index) {
          final reminder1 =
              (index * 2 < reminders.length) ? reminders[index * 2] : null;
          final reminder2 = (index * 2 + 1 < reminders.length)
              ? reminders[index * 2 + 1]
              : null;

          return Column(
            children: [
              if (reminder1 != null)
                Expanded(
                  child:
                      ReminderCard(reminder: reminder1, reminders: reminders),
                ),
              if (reminder2 != null)
                Expanded(
                  child:
                      ReminderCard(reminder: reminder2, reminders: reminders),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('reminders.json');
  final Map<String, dynamic> reminder;
  final List<dynamic> reminders;
  final FlutterTts tts = FlutterTts();
  var pressed_1 = false;

  ReminderCard({required this.reminder, required this.reminders});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.green,
              child: TextButton(
                onPressed: null,
                child: Text(
                  'Pill: ' +
                      reminder['medicineName'] +
                      '\nTime: ' +
                      reminder['Time'],
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.red,
              child: TextButton(
                onPressed: () {
                  if (!pressed_1) {
                    pressed_1 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    tts.speak('Delete ' + reminder['medicineName'] + '?');
                  } else {
                    reminders.remove(reminder);
                    storage.setItem('reminders', reminders);
                    pressed_1 = false;
                  }
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
