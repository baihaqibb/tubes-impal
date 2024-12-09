import 'package:flutter/material.dart';
import 'package:simple_cal/pages/edit_page.dart';
import 'package:simple_cal/themes.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String note;
  final String time;
  const EventCard({
    super.key,
    required this.title,
    required this.note,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => const EditPage())),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0).copyWith(
          left: 15,
        ),
        decoration: const BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: note.isNotEmpty
                    ? Text(
                        note,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
