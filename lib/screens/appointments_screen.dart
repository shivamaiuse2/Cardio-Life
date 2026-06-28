import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final upcoming = state.appointments
        .where((a) =>
            a.status == AppointmentStatus.confirmed ||
            a.status == AppointmentStatus.pending)
        .toList();
    final completed = state.appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList();
    final cancelled = state.appointments
        .where((a) => a.status == AppointmentStatus.cancelled)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Appointments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: AppColors.primary,
            onPressed: () => Navigator.pushNamed(context, '/book'),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'Upcoming (${upcoming.length})'),
            Tab(text: 'Completed (${completed.length})'),
            const Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _AppointmentList(
            appointments: upcoming,
            emptyMessage: 'No upcoming appointments',
            onTap: (a) => Navigator.pushNamed(context, '/appointment-detail', arguments: a),
            onCancel: (a) => state.cancelAppointment(a.id),
          ),
          _AppointmentList(
            appointments: completed,
            emptyMessage: 'No completed appointments',
            onTap: (a) => Navigator.pushNamed(context, '/appointment-detail', arguments: a),
          ),
          _AppointmentList(
            appointments: cancelled,
            emptyMessage: 'No cancelled appointments',
            onTap: (a) => Navigator.pushNamed(context, '/appointment-detail', arguments: a),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/book'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Book New', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;
  final String emptyMessage;
  final ValueChanged<Appointment> onTap;
  final ValueChanged<Appointment>? onCancel;

  const _AppointmentList({
    required this.appointments,
    required this.emptyMessage,
    required this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_outlined,
                size: 64, color: AppColors.textLight.withValues(alpha: (0.4))),
            const SizedBox(height: 16),
            Text(emptyMessage,
                style: const TextStyle(color: AppColors.textLight, fontSize: 15)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/book'),
              child: const Text('Book Appointment'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: appointments.length,
      itemBuilder: (context, i) {
        final a = appointments[i];
        return AppointmentCard(
          appointment: a,
          onTap: () => onTap(a),
          onCancel: onCancel != null ? () => onCancel!(a) : null,
        );
      },
    );
  }
}