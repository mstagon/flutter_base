import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event.dart';

const PRIMARY = "primary";
const ORANGE = "orange";
const WHITE = "white";
const Map<String, Color> myColors = {
  PRIMARY: Color.fromRGBO(255, 163, 63, 1),
  ORANGE: Color.fromRGBO(255, 209, 89, 1),
  WHITE: Colors.white
};

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();
  List<Event> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void _addEvent() {
    final title = _eventController.text;
    if (title.isNotEmpty) {
      final newEvent = Event(title: title, dateTime: selectedDay);
      setState(() {
        if (selectedEvents[selectedDay] == null) {
          selectedEvents[selectedDay] = [newEvent];
        } else {
          selectedEvents[selectedDay]!.add(newEvent);
        }
        _eventController.clear();
        _selectedEvents = selectedEvents[selectedDay]!;
      });
    }
  }

  void _deleteEvent(Event event) {
    setState(() {
      selectedEvents[selectedDay]?.remove(event);
      _selectedEvents = selectedEvents[selectedDay]!;
    });
  }

  void _showDeleteConfirmationDialog(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("일정 삭제 확인"),
        content: Text("정말로 이 일정을 삭제하시겠습니까?"),
        actions: [
          TextButton(
            child: Text("취소"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("삭제"),
            onPressed: () {
              _deleteEvent(event);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedEvents = selectedEvents[selectedDay] ?? [];

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        children: [
          Container(
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'AI DIARY',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                  _selectedEvents = selectedEvents[selectedDay] ?? [];
                });
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },
              eventLoader: _getEventsfromDay,
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 20.0,
                  color: Colors.blue,
                ),
                headerPadding: EdgeInsets.symmetric(vertical: 4.0),
                leftChevronIcon: Icon(
                  Icons.arrow_left,
                  size: 40.0,
                ),
                rightChevronIcon: Icon(
                  Icons.arrow_right,
                  size: 40.0,
                ),
              ),
            ),
          ),
          Column(
            children: _selectedEvents.map((event) {
              return ListTile(
                title: Text(event.title),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmationDialog(event),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("일정"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: Text("취소"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("추가"),
                onPressed: () {
                  _addEvent();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        label: Text("일정 추가"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
