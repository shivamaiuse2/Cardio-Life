import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationItem {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final String time;
  final bool unread;

  NotificationItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.time,
    this.unread = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      NotificationItem(
        icon: Icons.calendar_today_rounded,
        color: AppColors.primary,
        title: 'Appointment Confirmed',
        message: 'Your appointment with Dr. James Anderson is confirmed for 16 May, 10:00 AM.',
        time: '2h ago',
        unread: true,
      ),
      NotificationItem(
        icon: Icons.notifications_active_rounded,
        color: AppColors.warning,
        title: 'Appointment Reminder',
        message: 'You have an appointment tomorrow at 10:00 AM with Dr. James Anderson.',
        time: '5h ago',
        unread: true,
      ),
      NotificationItem(
        icon: Icons.description_outlined,
        color: AppColors.info,
        title: 'Lab Report Ready',
        message: 'Your ECG report is now available to view in the Reports section.',
        time: '1d ago',
      ),
      NotificationItem(
        icon: Icons.local_offer_outlined,
        color: AppColors.success,
        title: 'Special Offer',
        message: 'Get 20% off on your next Full Body Checkup this month.',
        time: '2d ago',
      ),
      NotificationItem(
        icon: Icons.medication_outlined,
        color: const Color(0xFF7C4DFF),
        title: 'Medication Reminder',
        message: "Don't forget to take your evening medication.",
        time: '3d ago',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Notifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _items = _items
                  .map((n) => NotificationItem(
                      icon: n.icon,
                      color: n.color,
                      title: n.title,
                      message: n.message,
                      time: n.time,
                      unread: false))
                  .toList();
            }),
            child: const Text('Mark all read',
                style: TextStyle(color: AppColors.primary, fontSize: 13)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, i) {
          final n = _items[i];
          return Dismissible(
            key: ValueKey(n.title + i.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
            ),
            onDismissed: (_) => setState(() => _items.removeAt(i)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: n.unread ? AppColors.lightRed.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: n.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(n.icon, color: n.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(n.title,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                            if (n.unread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: AppColors.primary, shape: BoxShape.circle),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(n.message,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textMedium, height: 1.4)),
                        const SizedBox(height: 6),
                        Text(n.time,
                            style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}