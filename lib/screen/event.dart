import 'package:flutter/foundation.dart';

class Event {
  final String title;
  final DateTime dateTime; // 이벤트의 날짜 및 시간

  Event({required this.title, required this.dateTime});

  String toString() => this.title;
}



class EventProvider with ChangeNotifier {
  Event? latestEvent; // 최신 이벤트
  Map<DateTime, List<Event>> events = {}; // 이벤트 목록을 저장하는 맵

  // 이벤트를 추가하고 latestEvent를 업데이트
  void addEvent(String title, DateTime dateTime) {
    latestEvent = Event(title: title, dateTime: dateTime);
    if (events[dateTime] == null) {
      events[dateTime] = [latestEvent!];
    } else {
      events[dateTime]!.add(latestEvent!);
    }
    notifyListeners(); // 상태 변경을 알리고 위젯들에게 새 데이터를 푸쉬
  }

  // 특정 날짜에 대한 이벤트 목록을 반환
  List<Event> getEventsForDay(DateTime date) {
    return events[date] ?? [];
  }
}


