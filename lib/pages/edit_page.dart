// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:simple_cal/services/alarm.dart';
import 'package:simple_cal/services/firestore.dart';
import 'package:simple_cal/services/notification.dart';
import 'package:simple_cal/themes.dart';
import 'package:intl/intl.dart';
import 'package:simple_cal/widgets/input_field.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.event});
  final DocumentSnapshot event;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  FirestoreService firestoreService = FirestoreService();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat.Hm().format(DateTime.now()).toString();
  String _endTime = DateFormat.Hm().format(DateTime.now()).toString();
  bool _reminderSwitch = true;
  String _selectedUrgency = "Notify";
  List<String> urgencyList = ["Notify", "Alarm"];
  int _selectedReminder = 15;
  List<int> reminderList = [5, 10, 15, 30, 60];
//  bool _repeatSwitch = false;
//  String _selectedRepeat = "Daily";
//  List<String> repeatList = ["Daily", "Weekly", "Monthly"];
//  DateTime _selectedUntilDate = DateTime.now();

  String _selectedUrgencyPrev = "Notify";
  int _selectedReminderPrev = 15;
//  String _selectedRepeatPrev = "Daily";
//  DateTime _selectedUntilDatePrev = DateTime.now();

  final _titleControl = TextEditingController();
  final _dateControl = TextEditingController();
  final _startTimeControl = TextEditingController();
  final _endTimeControl = TextEditingController();
  final _noteControl = TextEditingController();
  final _urgencyControl = TextEditingController();
  final _reminderControl = TextEditingController();
//  final _repeatControl = TextEditingController();
//  final _repeatUntilControl = TextEditingController();

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: danger,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DocumentSnapshot data = widget.event;

    _titleControl.text = data['title'];
    _selectedDate = data['date'].toDate();
    _dateControl.text = DateFormat("EEEE, dd MMMM yyyy").format(_selectedDate);
    _startTimeControl.text = data['start_time'];
    _startTime = data['start_time'];
    _endTimeControl.text = data['end_time'];
    _endTime = data['end_time'];
    _noteControl.text = data['note'];
    _reminderSwitch = data['reminder'];
    _selectedUrgency = data['reminder_urgency'] ?? 'Notify';
    _urgencyControl.text = _selectedUrgency;
    _selectedReminder = data['reminder_before'] ?? 15;
    _reminderControl.text = _selectedReminder >= 60
        ? (_selectedReminder ~/ 60).toString() +
            (_selectedReminder ~/ 60 == 1 ? " hour" : " hours")
        : _selectedReminder.toString() +
            (_selectedReminder == 1 ? " min" : " mins");
//    _repeatSwitch = data['repeat'];
//    _selectedRepeat = data['repeat_interval'] ?? 'Daily';
//    _repeatControl.text = _selectedRepeat;
//   _selectedUntilDate = data['repeat_until'] == Null
//        ? data['repeat_until'].toDate()
//        : DateTime.now();
//    _repeatUntilControl.text =
//        DateFormat("dd/MM/yy").format(_selectedUntilDate);
    /*
      showErrorSnackBar(e.toString());
      Navigator.pop(context);
      _dateControl.text =
          DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now());
      _startTimeControl.text =
          DateFormat.Hm().format(DateTime.now()).toString();
      _endTimeControl.text = DateFormat.Hm()
          .format(DateTime.now().add(const Duration(hours: 3)))
          .toString();
      _urgencyControl.text = "Medium";
      _reminderControl.text = "15 mins";
      _repeatControl.text = "Daily";
      _repeatUntilControl.text =
          DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now());*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _editBody(),
    );
  }

  Container _editBody() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleInputField(),
            _dateInputField(),
            Row(
              children: [
                Expanded(child: _startTimeInputField()),
                const SizedBox(
                  width: 20,
                ),
                _endTimeInputField()
              ],
            ),
            _noteInputField(),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            _reminderInputToggle(),
            if (_reminderSwitch)
              Row(
                children: [
                  Expanded(child: _urgencyInputField()),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _reminderInputField(),
                  ),
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            /*
            const Divider(),
            _repeatInputToggle(),
            if (_repeatSwitch)
              Row(
                children: [
                  Expanded(
                    child: _repeatInputField(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _repeatUntilInputField(),
                  ),
                ],
              ),
              */
            const SizedBox(
              height: 30,
            ),
            _editScheduleButton(),
            const SizedBox(
              height: 20,
            ),
            _deleteScheduleButton()
          ],
        ),
      ),
    );
  }

/*
  Row _repeatInputToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Repeat",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Switch(
            value: _repeatSwitch,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _selectedRepeat = _selectedRepeatPrev;
                  _selectedUntilDate = _selectedUntilDatePrev;
                  _repeatControl.text = _selectedRepeat;
                  _repeatUntilControl.text =
                      DateFormat("dd/MM/yy").format(_selectedUntilDate);
                } else {
                  _selectedRepeatPrev = _selectedRepeat == "None"
                      ? _selectedRepeatPrev
                      : _selectedRepeat;
                  _selectedUntilDatePrev = _selectedUntilDate == DateTime(1970)
                      ? _selectedUntilDatePrev
                      : _selectedUntilDate;
                  _selectedRepeat = "None";
                  _selectedUntilDate = DateTime(1970);
                }
                _repeatSwitch = value;
              });
            })
      ],
    );
  }
*/
  Row _reminderInputToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Reminder",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Switch(
            value: _reminderSwitch,
            onChanged: (value) {
              setState(() {
                if (value) {
                  _selectedUrgency = _selectedUrgencyPrev;
                  _selectedReminder = _selectedReminderPrev;
                  _urgencyControl.text = _selectedUrgency;
                  _reminderControl.text = _selectedReminder >= 60
                      ? (_selectedReminder ~/ 60).toString() +
                          (_selectedReminder ~/ 60 == 1 ? " hour" : " hours")
                      : _selectedReminder.toString() +
                          (_selectedReminder == 1 ? " min" : " mins");
                } else {
                  _selectedUrgencyPrev = _selectedUrgency == "None"
                      ? _selectedUrgencyPrev
                      : _selectedUrgency;
                  _selectedReminderPrev = _selectedReminder == 0
                      ? _selectedReminderPrev
                      : _selectedReminder;
                  _selectedUrgency = "None";
                  _selectedReminder = 0;
                }
                _reminderSwitch = value;
              });
            })
      ],
    );
  }

/*
  MyInputField _repeatUntilInputField() {
    return MyInputField(
      controller: _repeatUntilControl,
      title: "Until",
      hint: DateFormat("dd/MM/yy").format(DateTime.now()),
      widget: IconButton(
          onPressed: () {
            _getUntilDateFromUser(_selectedRepeat);
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey,
          )),
    );
  }
*/
  MyInputField _urgencyInputField() {
    return MyInputField(
      controller: _urgencyControl,
      title: "Urgency",
      hint: _selectedUrgency,
      widget: Expanded(
        child: DropdownButton(
          isExpanded: true,
          padding: const EdgeInsets.only(right: 10),
          items: urgencyList.map<DropdownMenuItem<String>>((String value) {
            if (value == "Notify") {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(value.toString()),
              );
            } else {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(
                  value.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                enabled: false,
              );
            }
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedUrgency = newValue!;
              _urgencyControl.text = newValue;
            });
          },
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          iconSize: 30,
          elevation: 4,
          underline: Container(
            height: 0,
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Container _deleteScheduleButton() {
    return Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 40),
        child: ElevatedButton(
          iconAlignment: IconAlignment.start,
          onPressed: () {
            showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Delete Event"),
                content: Text(
                    "Are you sure you want to delete ${widget.event['title']}?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          if (widget.event['reminder_id'] != null) {
                            await NotificationService.unscheduleNotification(
                                widget.event['reminder_id']);
                          }
                          firestoreService.deleteEvent(event: widget.event);
                        } catch (e) {
                          showErrorSnackBar(e.toString());
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: danger),
                      ))
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "Delete Schedule",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }

  Container _editScheduleButton() {
    // ignore: sized_box_for_whitespace
    return Container(
        height: 50,
        child: ElevatedButton(
          iconAlignment: IconAlignment.start,
          onPressed: () async {
            String id = widget.event.id;
            if (widget.event['reminder_id'] != Null) {
              if (widget.event['reminder_urgency'] == "Notify") {
                await NotificationService.unscheduleNotification(
                    widget.event['reminder_id']);
              } /* else if (widget.event['reminder_urgency'] == "Alarm") {
                await AlarmService.stopAlarm(widget.event['reminder_id']);
              } */
            }
            try {
              firestoreService.editEvent(
                  event: widget.event,
                  user: FirebaseAuth.instance.currentUser!.uid,
                  title: _titleControl.text.trim(),
                  date: _selectedDate,
                  startTime: _startTime.trim(),
                  endTime: _endTime.trim(),
                  note: _noteControl.text.trim(),
                  reminder: _reminderSwitch,
                  reminderID: _reminderSwitch ? id.hashCode : null,
                  reminderUrgency: _urgencyControl.text.trim(),
                  reminderBefore: _selectedReminder); //,
              //repeat: _repeatSwitch,
              //repeatInterval: _repeatControl.text.trim(),
              //repeatUntil: _selectedUntilDate);
              if (_reminderSwitch) {
                if (_selectedUrgency == "Notify") {
                  NotificationService.scheduleNotification(
                      id.hashCode,
                      _titleControl.text.trim(),
                      "${_startTime.trim()} - ${_endTime.trim()}",
                      _selectedDate
                          .add(Duration(
                              hours: int.parse(_startTime.split(":")[0]),
                              minutes: int.parse(_startTime.split(":")[1])))
                          .subtract(Duration(minutes: _selectedReminder)));
                } /* else if (_selectedUrgency == "Alarm") {
                  AlarmService.setAlarm(
                      id: id.hashCode,
                      title: _titleControl.text.trim(),
                      body:
                          "${_startTime.trim()} - ${_endTime.trim()}\n${_noteControl.text.trim()}",
                      dateTime: _selectedDate
                          .add(Duration(
                              hours: int.parse(_startTime.split(":")[0]),
                              minutes: int.parse(_startTime.split(":")[1])))
                          .subtract(Duration(minutes: _selectedReminder)));
                } */
              }
            } catch (e) {
              showErrorSnackBar(e.toString());
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Text(
                "Edit Schedule",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }

/*
  MyInputField _repeatInputField() {
    return MyInputField(
      controller: _repeatControl,
      title: "Interval",
      hint: _selectedRepeat,
      widget: Expanded(
        child: DropdownButton(
          isExpanded: true,
          padding: const EdgeInsets.only(right: 10),
          items: repeatList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRepeat = newValue!;
              _repeatControl.text = newValue;
            });
          },
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          iconSize: 30,
          elevation: 4,
          underline: Container(
            height: 0,
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
*/
  MyInputField _reminderInputField() {
    return MyInputField(
      controller: _reminderControl,
      title: "Remind before",
      hint: _selectedReminder >= 60
          ? (_selectedReminder ~/ 60).toString() +
              (_selectedReminder ~/ 60 == 1 ? " hour" : " hours")
          : _selectedReminder.toString() +
              (_selectedReminder == 1 ? " min" : " mins"),
      widget: Expanded(
        child: DropdownButton(
          isExpanded: true,
          padding: const EdgeInsets.only(right: 10),
          items: reminderList.map<DropdownMenuItem<String>>((int value) {
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(value.toString()),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedReminder = int.parse(newValue!);
              _reminderControl.text = _selectedReminder >= 60
                  ? (_selectedReminder ~/ 60).toString() +
                      (_selectedReminder ~/ 60 == 1 ? " hour" : " hours")
                  : _selectedReminder.toString() +
                      (_selectedReminder == 1 ? " min" : " mins");
            });
          },
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          iconSize: 30,
          elevation: 4,
          underline: Container(
            height: 0,
          ),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  MyInputField _noteInputField() {
    return MyInputField(
      controller: _noteControl,
      title: "Notes",
      hint: "e.g. Learning about databases",
    );
  }

  Expanded _endTimeInputField() {
    return Expanded(
        child: MyInputField(
      controller: _endTimeControl,
      title: "End",
      hint: _endTime,
      widget: IconButton(
          onPressed: () {
            _getTimeFromUser(isStartTime: false);
          },
          icon: const Icon(
            Icons.access_time_rounded,
            color: Colors.grey,
          )),
    ));
  }

  MyInputField _startTimeInputField() {
    return MyInputField(
      controller: _startTimeControl,
      title: "Start",
      hint: _startTime,
      widget: IconButton(
          onPressed: () {
            _getTimeFromUser(isStartTime: true);
          },
          icon: const Icon(
            Icons.access_time_rounded,
            color: Colors.grey,
          )),
    );
  }

  MyInputField _dateInputField() {
    return MyInputField(
      controller: _dateControl,
      title: "Day and Date",
      hint: DateFormat("EEEE, dd MMMM y").format(_selectedDate),
      widget: IconButton(
          onPressed: () {
            _getDateFromUser();
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey,
          )),
    );
  }

  MyInputField _titleInputField() {
    return MyInputField(
      controller: _titleControl,
      title: "Title",
      hint: "e.g. Software Implementation Class",
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Edit Schedule",
        style: textStyleTitle,
      ),
      backgroundColor: primary,
      centerTitle: true,
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(
            DateTime.now().year - 10, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month,
            DateTime.now().day));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        /*
        if (_selectedUntilDate.isBefore(_selectedDate)) {
          _repeatUntilControl.text =
              DateFormat("dd/MM/yy").format(_selectedDate);
          _selectedUntilDate = _selectedDate;
        }
        */
        _dateControl.text = DateFormat("EEEE, dd MMMM y").format(_pickerDate);
      });
    } else {
      print("something went wrong womp womp :(");
    }
  }

/*
  _getUntilDateFromUser(String interval) async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedUntilDate,
        firstDate: DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day),
        lastDate: interval == 'Daily'
            ? DateTime(
                _selectedDate.year, _selectedDate.month + 1, _selectedDate.day)
            : interval == 'Weekly'
                ? DateTime(_selectedDate.year, _selectedDate.month + 6,
                    _selectedDate.day)
                : DateTime(_selectedDate.year + 1, _selectedDate.month,
                    _selectedDate.day));

    if (_pickerDate != null) {
      setState(() {
        _selectedUntilDate = _pickerDate;
        _repeatUntilControl.text =
            DateFormat("dd/MM/yy").format(_selectedUntilDate);
      });
    } else {
      print("something went wrong womp womp :(");
    }
  }
*/
  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(isStartTime);
    if (pickedTime == null) {
      print("cancelled");
    } else if (isStartTime) {
      String _formattedTime = pickedTime.format(context);
      setState(() {
        _startTime = _formattedTime;
        _startTimeControl.text = _startTime;
      });
    } else if (!isStartTime) {
      String _formattedTime = pickedTime.format(context);
      setState(() {
        _endTime = _formattedTime;
        _endTimeControl.text = _endTime;
      });
    }
  }

  _showTimePicker(bool isStartTime) {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child ?? Container()),
        initialTime: isStartTime
            ? TimeOfDay(
                hour: int.parse(_startTime.split(":")[0]),
                minute: int.parse(_startTime.split(":")[1]))
            : TimeOfDay(
                hour: int.parse(_endTime.split(":")[0]),
                minute: int.parse(_endTime.split(":")[1])));
  }
}
