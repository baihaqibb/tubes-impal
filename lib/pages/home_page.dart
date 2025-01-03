import "package:cloud_firestore/cloud_firestore.dart";
import "package:date_picker_timeline/date_picker_widget.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:simple_cal/pages/input_page.dart";
import "package:simple_cal/services/firestore.dart";
import "package:simple_cal/themes.dart";
import "package:simple_cal/widgets/event_card.dart";
import "package:table_calendar/table_calendar.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  int currentPageIndex = 0;
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  final logoutSnackbar = const SnackBar(content: Text("User logged out"));

  final user = FirebaseAuth.instance.currentUser!;

  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return -((to.difference(from).inHours / 24).round());
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(logoutSnackbar);
  }

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
                const CircleAvatar(
                  radius: 30,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(user.email!)
              ],
            )),
            const ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
            ),
            ListTile(
              title: Text("Log Out"),
              leading: Icon(Icons.logout),
              onTap: logout,
            )
          ],
        ),
      ),
      body: <Widget>[
        _homePageCalendarView(),
        _homePageScheduleView()
      ][currentPageIndex],
      floatingActionButton: currentPageIndex == 1
          ? null
          : FloatingActionButton(
              backgroundColor: primary,
              foregroundColor: const Color(0xFFFAFAFA),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InputPage(
                              calendarDate: today,
                            )));
              },
              child: const Icon(Icons.add),
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

  Column _homePageScheduleView() {
    return Column(
      children: [
        _dateShown(),
        _dateBar(),
        StreamBuilder(
            stream: firestoreService.events
                .where('user',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where('date', isEqualTo: Timestamp.fromDate(_selectedDate))
                .orderBy('start_time')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Text("There's nothing here...");
              }

              return Expanded(
                  child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: EventCard(
                          event: snapshot.data!.docs[index],
                          title: snapshot.data!.docs[index]['title'],
                          note: snapshot.data!.docs[index]['note'],
                          time: snapshot.data!.docs[index]['start_time'] +
                              " - " +
                              snapshot.data!.docs[index]['end_time'],
                        ),
                      )
                    ],
                  );
                },
              ));
            })
      ],
    );
  }

  Container _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: _selectedDate,
        selectionColor: primary,
        selectedTextColor: Colors.white,
        monthTextStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        dateTextStyle: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        dayTextStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        daysCount: 30,
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
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
                  DateFormat("d MMMM yyyy").format(_selectedDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  daysBetween(_selectedDate, DateTime.now()) == 0
                      ? "Today"
                      : daysBetween(_selectedDate, DateTime.now()) == 1
                          ? "Tomorrow"
                          : "${daysBetween(_selectedDate, DateTime.now())} days after",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InputPage(calendarDate: _selectedDate)));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: const Color(0xFFFAFAFA),
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
                  "Add Event",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView _homePageCalendarView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
            child: TableCalendar(
              weekendDays: const [DateTime.sunday],
              locale: "en_US",
              rowHeight: 80,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              availableGestures: AvailableGestures.horizontalSwipe,
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
                todayDecoration: BoxDecoration(
                    color: const Color(0x00000000),
                    border: Border.all(color: primary, width: 2),
                    shape: BoxShape.circle),
                selectedDecoration:
                    const BoxDecoration(color: primary, shape: BoxShape.circle),
                weekNumberTextStyle: const TextStyle(color: Colors.red),
                weekendTextStyle: const TextStyle(color: Colors.red),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              focusedDay: today,
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2049, 12, 31),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
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
