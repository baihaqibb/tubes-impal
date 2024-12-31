import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:uuid/uuid.dart';

class FirestoreService {
  final CollectionReference events =
      FirebaseFirestore.instance.collection("events");

  Future<DocumentReference?> addEvent({
    required String id,
    required String user,
    required String title,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? note,
    required bool reminder,
    int? reminderID,
    String? reminderUrgency,
    int? reminderBefore,
    //required bool repeat,
    //String? repeatInterval,
    //DateTime? repeatUntil
  }) async {
    try {
      await events.doc(id).set({
        'user': user,
        'title': title.isNotEmpty ? title : "Untitled",
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'note': note ?? "",
        'reminder': reminder,
        'reminder_id': reminderID,
        'reminder_urgency': reminder ? reminderUrgency : null,
        'reminder_before': reminder ? reminderBefore : null,
        //'repeat': repeat,
        //'repeat_interval': repeat ? repeatInterval : null,
        //'repeat_until': repeat ? repeatUntil : null
      });
      return events.doc(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editEvent({
    required DocumentSnapshot event,
    required String user,
    required String title,
    required DateTime date,
    required String startTime,
    required String endTime,
    String? note,
    required bool reminder,
    int? reminderID,
    String? reminderUrgency,
    int? reminderBefore,
    //required bool repeat,
    //String? repeatInterval,
    //DateTime? repeatUntil
  }) async {
    try {
      await events.doc(event.id).set({
        'user': user,
        'title': title.isNotEmpty ? title : "Untitled",
        'date': date,
        'start_time': startTime,
        'end_time': endTime,
        'note': note ?? "",
        'reminder': reminder,
        'reminder_id': reminderID,
        'reminder_urgency': reminder ? reminderUrgency : null,
        'reminder_before': reminder ? reminderBefore : null,
        //'repeat': repeat,
        //'repeat_interval': repeat ? repeatInterval : null,
        //'repeat_until': repeat ? repeatUntil : null
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent({required DocumentSnapshot event}) async {
    try {
      await events.doc(event.id).delete();
    } catch (e) {
      rethrow;
    }
  }
}
