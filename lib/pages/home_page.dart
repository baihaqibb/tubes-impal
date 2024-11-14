import "package:date_picker_timeline/date_picker_widget.dart";
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:simple_cal/notifications/notification.dart";
import "package:simple_cal/themes.dart";
import "package:table_calendar/table_calendar.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homePageAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Username")
              ],
            )),
            ListTile(
              title: Text("Settings"),
            ),
            ListTile(
              title: Text("Log Out"),
            )
          ],
        ),
      ),
      body: <Widget>[
        _homePageCalendarView(),
        Column(
          children: [
            _dateShown(),
            _datePicker(),
          ],
        )
      ][currentPageIndex],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        foregroundColor: const Color(0xFFFAFAFA),
        onPressed: () {},
        label: const Text("Add Event"),
        icon: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: "Calendar"),
          NavigationDestination(icon: Icon(Icons.schedule), label: "Schedule")
        ],
      ),
    );
  }

  Container _datePicker() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primary,
        selectedTextColor: Colors.white,
        monthTextStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        dateTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        dayTextStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
      ),
    );
  }

  Container _dateShown() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
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
          margin:
              const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 40),
          child: TableCalendar(
              weekendDays: [DateTime.sunday],
              locale: "en_US",
              rowHeight: 80,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.all,
              onDaySelected: (day, focusedDay) {
                setState(() {
                  today = day;
                });
              },
              selectedDayPredicate: (day) => isSameDay(day, today),
              daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                  weekdayStyle: TextStyle()),
              calendarStyle: CalendarStyle(
                weekNumberTextStyle: const TextStyle(color: Colors.red),
                weekendTextStyle: const TextStyle(color: Colors.red),
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
      title: const Text(
        "SimpleCalendar :)",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }
}
