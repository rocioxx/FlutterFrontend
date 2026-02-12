import 'package:flutter/material.dart';
import 'absences_screen.dart';
import 'schedule_screen.dart';
import 'on_call_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isClockedIn = false;
  DateTime? _clockInTime;

  void _toggleClockIn() {
    setState(() {
      _isClockedIn = !_isClockedIn;
      if (_isClockedIn) {
        _clockInTime = DateTime.now();
      } else {
        _clockInTime = null;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isClockedIn
              ? 'Has fichado entrada a las ${TimeOfDay.now().format(context)}'
              : 'Has fichado salida',
        ),
        backgroundColor: _isClockedIn ? Colors.green : Colors.red,
      ),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    AbsencesScreen(),
    ScheduleScreen(),
    OnCallScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Profesores'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          if (_selectedIndex == 0) ...[
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withOpacity(0.3),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isClockedIn
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isClockedIn ? Icons.timer : Icons.timer_off,
                          color: _isClockedIn
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isClockedIn
                                  ? 'Jornada Activa'
                                  : 'Fuera de Jornada',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            if (_isClockedIn && _clockInTime != null)
                              Text(
                                'Desde: ${_clockInTime!.hour}:${_clockInTime!.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(color: Colors.grey.shade600),
                              )
                            else
                              Text(
                                'Registra tu entrada',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                          ],
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _toggleClockIn,
                        style: FilledButton.styleFrom(
                          backgroundColor: _isClockedIn
                              ? Colors.red
                              : Colors.green,
                        ),
                        icon: Icon(
                          _isClockedIn ? Icons.stop : Icons.play_arrow,
                        ),
                        label: Text(_isClockedIn ? 'Salir' : 'Entrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person_off_outlined),
            selectedIcon: Icon(Icons.person_off),
            label: 'Ausencias',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Horario',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Guardias',
          ),
        ],
      ),
    );
  }
}
