import "package:date_picker_timeline/date_picker_widget.dart";
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:simple_cal/pages/themes.dart";
import "package:table_calendar/table_calendar.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageAppBar(),
      drawer: Drawer(),
      body: <Widget>[
        _homePageCalendarView(),
        Column(
          children: [_dateShown(), _datePicker()],
        )
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: Color(0xFFFAFAFA),
        onPressed: () {},
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          NavigationDestination(icon: Icon(Icons.schedule), label: "Schedule")
        ],
      ),
    );
  }

  Container _datePicker() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primary,
        selectedTextColor: Colors.white,
        monthTextStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        dateTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        dayTextStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }

  Container _dateShown() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd("en_US").format(DateTime.now()),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Today",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _homePageCalendarView() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 40),
          child: TableCalendar(
              locale: "en_US",
              rowHeight: 80,
              headerStyle:
                  HeaderStyle(formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              onDaySelected: (day, focusedDay) {
                setState(() {
                  today = day;
                });
              },
              selectedDayPredicate: (day) => isSameDay(day, today),
              daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                  weekdayStyle: TextStyle()),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xA09FA8DA)),
                selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x00),
                    border: Border.all(width: 3, color: Color(0xA05C6BC0))),
                outsideTextStyle: TextStyle(color: Color(0x80A0A0A0)),
                weekNumberTextStyle: TextStyle(color: Colors.red),
                weekendTextStyle: TextStyle(color: Colors.red),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              focusedDay: today,
              firstDay: DateTime.utc(1970, 01, 01),
              lastDay: DateTime.utc(2099, 12, 31)),
        )
      ],
    );
  }

  AppBar homePageAppBar() {
    return AppBar(
      backgroundColor: primary,
      title: Text(
        "SimpleCalendar :)",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
