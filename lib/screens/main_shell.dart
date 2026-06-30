import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';
import 'home_screen.dart';
import 'book_appointment_screen.dart';
import 'reports_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static final _screens = [
    const HomeScreen(),
    const BookAppointmentScreen(),
    const ReportsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: IndexedStack(
        sizing: StackFit.expand,
        index: state.currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: state.currentIndex,
        onTap: state.setIndex,
      ),
    );
  }
}