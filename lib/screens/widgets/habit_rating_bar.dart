import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitRatingBar extends StatefulWidget {
  final String userId;
  final int habitIndex;
  final double initialRate;
  final int timesADay;

  const HabitRatingBar({
    Key? key,
    required this.userId,
    required this.habitIndex,
    required this.initialRate,
    required this.timesADay,
  }) : super(key: key);

  @override
  State<HabitRatingBar> createState() => _HabitRatingBarState();
}

class _HabitRatingBarState extends State<HabitRatingBar> {
  late double _currentRate;

  @override
  void initState() {
    super.initState();
    _currentRate = widget.initialRate;
  }

  Future<void> _updateHabitRate(double value) async {
    try {
      // Round up if the value has any decimal part
      int roundedValue = value % 1 > 0 ? value.ceil() : value.toInt();

      // Reference to the habit document
      final habitDocRef =
          FirebaseFirestore.instance.collection('Users').doc(widget.userId);

      // Fetch the current document data to get the existing habits
      final docSnapshot = await habitDocRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> habits = data['habits'] ?? [];

        // Modify the specific habit's "done" field at the specified index
        habits[widget.habitIndex]['done'] = roundedValue;

        // Update the entire list of habits in Firestore
        await habitDocRef.update({'habits': habits});

        setState(() {
          _currentRate = roundedValue.toDouble();
        });

        print('Habit updated successfully');
      } else {
        print('User data not found');
      }
    } catch (error) {
      print('Failed to update habit: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PannableRatingBar(
      rate: _currentRate,
      items: List.generate(
        widget.timesADay,
        (index) => RatingWidget(
          selectedColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Colors.grey,
          child: const Icon(
            Icons.done_all,
            size: 30,
          ),
        ),
      ),
      onChanged: _updateHabitRate,
    );
  }
}
