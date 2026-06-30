import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';

class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String? _selectedSlot;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  AppointmentType _selectedType = AppointmentType.initialConsultation;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final doctor = widget.doctor;
    final isFav = state.isFavorite(doctor);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: Colors.white,
                ),
                onPressed: () => state.toggleFavorite(doctor),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/chat', arguments: doctor),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF8B0000), Color(0xFFB71C1C)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(doctor.avatarUrl),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(doctor.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(doctor.specialty,
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: (0.85)),
                                      fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(doctor.qualification,
                                  style: TextStyle(
                                      color: Colors.white.withValues(alpha: (0.7)),
                                      fontSize: 12)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  RatingStars(rating: doctor.rating, size: 14),
                                  const SizedBox(width: 6),
                                  Text('${doctor.rating}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text('(${doctor.reviewCount})',
                                      style: TextStyle(
                                          color: Colors.white.withValues(alpha: (0.7)),
                                          fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: doctor.isAvailable
                                      ? AppColors.success.withValues(alpha: (0.2))
                                      : Colors.grey.withValues(alpha: (0.2)),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: doctor.isAvailable
                                        ? AppColors.success
                                        : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  doctor.isAvailable ? '● Available' : '● Unavailable',
                                  style: TextStyle(
                                    color: doctor.isAvailable
                                        ? AppColors.success
                                        : Colors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Stats row
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      _Stat(value: '${doctor.experience}+', label: 'Years Exp.'),
                      _divider(),
                      _Stat(value: '${doctor.reviewCount}+', label: 'Patients'),
                      _divider(),
                      _Stat(
                          value: doctor.rating.toString(), label: 'Rating'),
                      _divider(),
                      _Stat(
                          value: '\$${doctor.consultationFee.toInt()}',
                          label: 'Per Visit'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Hospital info
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.local_hospital_outlined,
                            color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doctor.hospital,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            const Text('View on Map',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.primary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColors.textLight),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tab,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textLight,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Book Appointment'),
                      Tab(text: 'About'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 520,
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _BookingTab(
                        doctor: doctor,
                        selectedDate: _selectedDate,
                        selectedSlot: _selectedSlot,
                        selectedType: _selectedType,
                        onDateChange: (d) => setState(() => _selectedDate = d),
                        onSlotChange: (s) => setState(() => _selectedSlot = s),
                        onTypeChange: (t) => setState(() => _selectedType = t),
                      ),
                      _AboutTab(doctor: doctor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedSlot != null
          ? _BottomBookButton(
              doctor: doctor,
              slot: _selectedSlot!,
              date: _selectedDate,
              type: _selectedType,
              onBook: () => _confirmBooking(context),
            )
          : null,
    );
  }

  void _confirmBooking(BuildContext context) {
    final state = context.read<AppState>();
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctor: widget.doctor,
      date: _selectedDate,
      timeSlot: _selectedSlot!,
      status: AppointmentStatus.pending,
      type: _selectedType,
      appointmentId: 'CLM${DateTime.now().millisecondsSinceEpoch % 1000000}',
    );
    state.addAppointment(appointment);
    Navigator.pushNamed(context, '/payment', arguments: appointment);
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
        ],
      ),
    );
  }
}

Widget _divider() => Container(
      width: 1,
      height: 36,
      color: AppColors.divider,
    );

class _BookingTab extends StatelessWidget {
  final Doctor doctor;
  final DateTime selectedDate;
  final String? selectedSlot;
  final AppointmentType selectedType;
  final ValueChanged<DateTime> onDateChange;
  final ValueChanged<String> onSlotChange;
  final ValueChanged<AppointmentType> onTypeChange;

  const _BookingTab({
    required this.doctor,
    required this.selectedDate,
    required this.selectedSlot,
    required this.selectedType,
    required this.onDateChange,
    required this.onSlotChange,
    required this.onTypeChange,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) => DateTime.now().add(Duration(days: i + 1)));
    final typeLabels = {
      AppointmentType.initialConsultation: 'Initial Consultation',
      AppointmentType.followUp: 'Follow-up',
      AppointmentType.checkup: 'General Checkup',
      AppointmentType.testScan: 'Test & Scan',
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visit type
          const Text('Visit Type',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: AppointmentType.values.map((type) {
                final sel = selectedType == type;
                return GestureDetector(
                  onTap: () => onTypeChange(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary : AppColors.chipBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(typeLabels[type]!,
                        style: TextStyle(
                          color: sel ? Colors.white : AppColors.textMedium,
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                        )),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Date selector
          const Text('Select Date',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final day = days[i];
                final sel = day.day == selectedDate.day && day.month == selectedDate.month;
                final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final dayName = dayNames[day.weekday - 1];
                return GestureDetector(
                  onTap: () => onDateChange(day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 54,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: sel ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dayName,
                            style: TextStyle(
                              fontSize: 11,
                              color: sel ? Colors.white70 : AppColors.textLight,
                            )),
                        const SizedBox(height: 4),
                        Text('${day.day}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: sel ? Colors.white : AppColors.textDark,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Time slots
          const Text('Select Time',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: doctor.availableSlots.map((slot) {
              final sel = selectedSlot == slot;
              return GestureDetector(
                onTap: () => onSlotChange(slot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: sel ? AppColors.primary : AppColors.divider),
                  ),
                  child: Text(slot,
                      style: TextStyle(
                        color: sel ? Colors.white : AppColors.textMedium,
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      )),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Fee summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightRed,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Consultation Fee',
                          style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
                      Text('Includes full consultation',
                          style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                    ],
                  ),
                ),
                Text('\$${doctor.consultationFee.toInt()}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final Doctor doctor;
  const _AboutTab({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(
            '${doctor.name} is a highly experienced ${doctor.specialty} with over ${doctor.experience} years of clinical expertise. '
            'Specializing in advanced cardiac care, ${doctor.name} has helped thousands of patients achieve better heart health. '
            'They are affiliated with ${doctor.hospital} and are known for their patient-centric approach.',
            style: const TextStyle(fontSize: 13, color: AppColors.textMedium, height: 1.6),
          ),
          const SizedBox(height: 20),
          const Text('Specializations',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Heart Failure', 'Arrhythmia', 'Coronary Disease',
              'Preventive Cardiology', 'Echo', 'Cardiac Rehab']
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.lightRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(s,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.primary,
                              fontWeight: FontWeight.w500)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text('Available Days',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: doctor.availableDays.map((d) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(d,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textDark,
                          fontWeight: FontWeight.w500)),
                )).toList(),
          ),
          const SizedBox(height: 20),
          // Reviews teaser
          const Text('Patient Reviews',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ...['Great doctor, very attentive!', 'Highly professional and experienced.',
            'Explained everything clearly.']
              .asMap()
              .entries
              .map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?img=${20 + e.key}'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Patient ${e.key + 1}',
                                  style: const TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(e.value,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.textMedium)),
                            ],
                          ),
                        ),
                        const RatingStars(rating: 5, size: 12),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}

class _BottomBookButton extends StatelessWidget {
  final Doctor doctor;
  final String slot;
  final DateTime date;
  final AppointmentType type;
  final VoidCallback onBook;

  const _BottomBookButton({
    required this.doctor,
    required this.slot,
    required this.date,
    required this.type,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabels = {
      AppointmentType.initialConsultation: 'Initial Consultation',
      AppointmentType.followUp: 'Follow-up',
      AppointmentType.checkup: 'General Checkup',
      AppointmentType.testScan: 'Test & Scan',
    };
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: (0.08)), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(slot,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  Text('${date.day}/${date.month}/${date.year} • ${typeLabels[type]}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
              const Spacer(),
              Text('\$${doctor.consultationFee.toInt()}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onBook,
              child: const Text('Confirm Appointment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}