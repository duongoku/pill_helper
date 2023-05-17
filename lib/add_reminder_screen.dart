import 'medicine_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'time_screen.dart';

class AddReminderScreen extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('reminders.json');

  @override
  Widget build(BuildContext context) {
    List<dynamic> reminders = storage.getItem('reminders') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Reminder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.green,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicineNameScreen(),
                    ),
                  );
                },
                child: Text(
                  'Add Medicine',
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
              color: Colors.blue,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeScreen(),
                    ),
                  );
                },
                child: Text(
                  'Add Time',
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
                  reminders.add(storage.getItem('currentReminder'));
                  reminders.sort((a, b) => a['Time'].compareTo(b['Time']));
                  storage.setItem('reminders', reminders);
                  Navigator.pop(context);
                },
                child: Text(
                  'Save Reminder',
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
