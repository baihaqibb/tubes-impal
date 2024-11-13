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
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat.Hm().format(DateTime.now()).toString();
  String _endTime = DateFormat.Hm().format(DateTime.now()).toString();
  bool _reminderSwitch = true;
  String _selectedUrgency = "Medium";
  List<String> urgencyList = ["Weak", "Medium", "Strong"];
  int _selectedReminder = 15;
  List<int> reminderList = [5, 10, 15, 30, 60];
  bool _repeatSwitch = false;
  String _selectedRepeat = "Daily";
  List<String> repeatList = ["Daily", "Weekly", "Monthly"];
  DateTime _selectedUntilDate = DateTime.now();

  String _selectedUrgencyPrev = "Medium";
  int _selectedReminderPrev = 15;
  String _selectedRepeatPrev = "Daily";
  DateTime _selectedUntilDatePrev = DateTime.now();

  final _titleControl = TextEditingController();
  final _dateControl = TextEditingController();
  final _startTimeControl = TextEditingController();
  final _endTimeControl = TextEditingController();
  final _noteControl = TextEditingController();
  final _urgencyControl = TextEditingController();
  final _reminderControl = TextEditingController();
  final _repeatControl = TextEditingController();
  final _repeatUntilControl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateControl.text = DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now());
    _startTimeControl.text = DateFormat.Hm().format(DateTime.now()).toString();
    _endTimeControl.text = DateFormat.Hm()
        .format(DateTime.now().add(const Duration(hours: 3)))
        .toString();
    _urgencyControl.text = "Medium";
    _reminderControl.text = "15 mins";
    _repeatControl.text = "Daily";
    _repeatUntilControl.text =
        DateFormat("EEEE, dd MMMM yyyy").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _inputBody(),
    );
  }

  Container _inputBody() {
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
            const SizedBox(
              height: 30,
            ),
            _inputScheduleButton(),
          ],
        ),
      ),
    );
  }

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

  MyInputField _repeatUntilInputField() {
    return MyInputField(
      controller: _repeatUntilControl,
      title: "Until",
      hint: DateFormat("dd/MM/yy").format(DateTime.now()),
      widget: IconButton(
          onPressed: () {
            _getUntilDateFromUser();
          },
          icon: const Icon(
            Icons.calendar_today_outlined,
            color: Colors.grey,
          )),
    );
  }

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
            return DropdownMenuItem<String>(
              value: value.toString(),
              child: Text(value.toString()),
            );
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

  Container _inputScheduleButton() {
    return Container(
        margin: const EdgeInsets.only(bottom: 40),
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
                "Input Schedule",
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
      title: "Input",
      hint: "e.g. Software Implementation Class",
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        "Input Schedule",
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
        _dateControl.text = DateFormat("EEEE, dd MMMM y").format(_pickerDate);
      });
    } else {
      print("something went wrong womp womp :(");
    }
  }

  _getUntilDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedUntilDate,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 10, DateTime.now().month,
            DateTime.now().day));

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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
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

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.dial,
        context: context,
        initialTime: TimeOfDay(
            hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute));
  }
}
