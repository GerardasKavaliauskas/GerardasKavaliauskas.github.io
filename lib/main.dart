import 'package:flutter/material.dart';

import 'pages/home/page.dart';
import 'pages/bill_predictor/page.dart';

void main() {
  runApp(const EnergySchedulerApp());
}

class EnergySchedulerApp extends StatelessWidget {
  const EnergySchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const BillPredictorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Energy Scheduler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Bill Predictor',
          ),
        ],
      ),
    );
  }
}
