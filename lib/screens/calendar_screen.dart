// lib/screens/calendar_screen.dart - FIXED VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/content_provider.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<dynamic>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _events = {};
  }

  List<dynamic> _getEventsForDay(DateTime day, List<dynamic> allEvents) {
    return allEvents.where((event) {
      if (event.date != null) {
        return isSameDay(event.date, day);
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);
    final events = contentProvider.getContentByType('event');

    return Scaffold(
      body: Column(
        children: [
          AppHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Church Calendar',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Stay connected with our events and activities',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  // Calendar Widget
                  Container(
                    constraints: BoxConstraints(maxWidth: 1000),
                    padding: EdgeInsets.all(20),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          eventLoader: (day) => _getEventsForDay(day, events),
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                            selectedDecoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            todayDecoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: true,
                            titleCentered: true,
                            formatButtonDecoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            formatButtonTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                            titleTextStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                        ),
                      ),
                    ),
                  ),

                  // Selected Day Events
                  if (_selectedDay != null) ...[
                    Container(
                      constraints: BoxConstraints(maxWidth: 1000),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Events on ${DateFormat('MMMM d, y').format(_selectedDay!)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(height: 20),
                          ..._getEventsForDay(_selectedDay!, events).map(
                            (event) => _buildEventCard(event),
                          ),
                          if (_getEventsForDay(_selectedDay!, events).isEmpty)
                            Container(
                              padding: EdgeInsets.all(40),
                              child: Center(
                                child: Text(
                                  'No events scheduled for this day',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  // Upcoming Events Section
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Upcoming Events',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 1000),
                          child: Column(
                            children: [
                              ...events.where((event) {
                                // Fixed: Check if date is not null before calling isAfter
                                if (event.date != null) {
                                  return event.date!.isAfter(DateTime.now());
                                }
                                return false;
                              }).take(5).map((event) => _buildUpcomingEventCard(event)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Regular Weekly Schedule
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                    child: Column(
                      children: [
                        Text(
                          'Weekly Schedule',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          child: Column(
                            children: [
                              _buildScheduleItem('Sunday', [
                                '9:00 AM - Sunday School',
                                '10:30 AM - Morning Worship',
                                '6:00 PM - Evening Service',
                              ]),
                              _buildScheduleItem('Wednesday', [
                                '7:00 PM - Bible Study',
                                '7:00 PM - Youth Group',
                              ]),
                              _buildScheduleItem('Friday', [
                                '7:00 PM - Prayer Meeting',
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(dynamic event) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.event,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          event.title ?? 'Untitled Event',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: event.description != null ? Text(event.description!) : null,
        trailing: event.date != null
            ? Text(
                DateFormat('h:mm a').format(event.date!),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildUpcomingEventCard(dynamic event) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.date != null ? '${event.date!.day}' : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    event.date != null ? DateFormat('MMM').format(event.date!) : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title ?? 'Untitled Event',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (event.description != null) ...[
                    SizedBox(height: 5),
                    Text(
                      event.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  if (event.date != null) ...[
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 5),
                        Text(
                          DateFormat('EEEE, h:mm a').format(event.date!),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String day, List<String> activities) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: activities.map((activity) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    activity,
                    style: TextStyle(fontSize: 16),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}