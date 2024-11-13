// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:simple_cal/themes.dart';
import 'package:intl/intl.dart';
import 'package:simple_cal/widgets/input_field.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  DateFormat dateFormatID = DateFormat("E, dd/MM/y");
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat.Hm().format(DateTime.now()).toString();
  String _endTime = "19:30";
  int _selectedReminder = 5;
  List<int> reminderList = [0, 5, 10, 15, 30, 60];
  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  final _titleControl = TextEditingController();
  final _dateControl = TextEditingController();
  final _startTimeControl = TextEditingController();
  final _endTimeControl = TextEditingController();
  final _noteControl = TextEditingController();
  final _reminderControl = TextEditingController();
  final _repeatControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
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
              Row(
                children: [
                  Expanded(
                    child: _reminderInputField(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _repeatInputField(),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              _addScheduleButton()
            ],
          ),
        ),
      ),
    );
  }

  Container _addScheduleButton() {
    return Container(
        height: 50,
        child: ElevatedButton(
          iconAlignment: IconAlignment.start,
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                "Add Schedule",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }

  MyInputField _repeatInputField() {
    return MyInputField(
      controller: _repeatControl,
      title: "Repeat",
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

  MyInputField _reminderInputField() {
    return MyInputField(
      controller: _reminderControl,
      title: "Remind before",
      hint: _selectedReminder == 0
          ? "Off"
          : _selectedReminder >= 60
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
              _reminderControl.text = _selectedReminder == 0
                  ? "Off"
                  : _selectedReminder >= 60
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
      hint: dateFormatID.format(_selectedDate),
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
      title: "Input",
      hint: "e.g. Software Implementation Class",
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Input Schedule",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        _dateControl.text = dateFormatID.format(_pickerDate);
      });
    } else {
      print("something went wrong womp womp :(");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print("cancelled");
    } else if (isStartTime) {
      setState(() {
        _startTime = _formattedTime;
        _startTimeControl.text = _startTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formattedTime;
        _endTimeControl.text = _endTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute));
  }
}
