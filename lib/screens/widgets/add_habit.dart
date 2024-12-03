import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({super.key});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  int _timesADay = 1;
  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");
  final TextEditingController _habitNameController =
      TextEditingController(); // TextEditingController

  @override
  void dispose() {
    _habitNameController
        .dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
          maxHeight: 600,
        ),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: _habitNameController, // Attach controller
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          labelText: 'Enter Habit Name',
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('How Many Times a Day '),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: NumberPicker(
                          value: _timesADay,
                          minValue: 0,
                          maxValue: 10,
                          selectedTextStyle: const TextStyle(
                            color: Colors.blue,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          infiniteLoop: true,
                          itemCount: 3,
                          axis: Axis.vertical,
                          onChanged: (value) =>
                              setState(() => _timesADay = value),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      String habitName =
                          _habitNameController.text.trim(); // Get habit name
                      if (habitName.isNotEmpty) {
                        addHabit(habitName, _timesADay);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Habit name cannot be empty'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: const Text('Add Habit'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addHabit(String habitName, int timesADay) async {
    // Get the user ID
    String userId = _boxAccounts.get(
      _boxLogin.get('userName') + 'ID',
    );

    // Reference the user's document
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('Users').doc(userId);

    try {
      // Add the habit to the 'habits' array
      await userDoc.set(
        {
          'habits': FieldValue.arrayUnion([
            {
              'habitName': habitName,
              'timesADay': timesADay,
              'done': 0,
            }
          ]),
        },
        SetOptions(
            merge: true), // Merge to avoid overwriting the entire document
      );
      print('Habit added successfully.');
    } catch (e) {
      print('Error adding habit: $e');
    }
  }
}
