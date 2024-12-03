import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracking/screens/widgets/add_habit.dart';
import 'package:habit_tracking/screens/widgets/habit_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth/login.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final Box _boxLogin = Hive.box("login");
  final Box _boxAccounts = Hive.box("accounts");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome 🎉 ${_boxLogin.get('userName')}',
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
              ),
              child: IconButton(
                onPressed: () {
                  _boxLogin.put("loginStatus", false);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(
              _boxAccounts.get(
                _boxLogin.get('userName') + 'ID',
              ),
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('No Habits Yet! Start and add more'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          final habits = data?['habits'] as List?;
          return ListView.builder(
            itemCount: habits?.length ?? 0,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            habits?[index]['habitName'],
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${habits?[index]['timesADay']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      HabitRatingBar(
                        userId: _boxAccounts.get(
                          _boxLogin.get('userName') + 'ID',
                        ),
                        habitIndex: index,
                        initialRate: habits?[index]['done'].toDouble(),
                        timesADay: habits?[index]['timesADay'],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalPopup(
            barrierDismissible: true,
            context: context,
            useRootNavigator: false,
            builder: (BuildContext modalContext) => const AddHabit(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
