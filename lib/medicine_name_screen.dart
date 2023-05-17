import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class MedicineNameScreen extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('reminders.json');
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentReminder =
        storage.getItem('currentReminder') ?? {'medicineName': '', 'Time': ''};

    @override
    void dispose() {
      textController.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Name'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Enter Medicine Name',
                  contentPadding: EdgeInsets.symmetric(vertical: 24.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
              child: TextButton(
                onPressed: () {
                  currentReminder['medicineName'] = textController.text;
                  storage.setItem('currentReminder', currentReminder);
                  Navigator.pop(context);
                },
                child: Text(
                  'Confirm',
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
