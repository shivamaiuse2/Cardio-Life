import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  ServiceCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final filtered = _selectedCategory == null
        ? AppData.services
        : AppData.services.where((s) => s.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 130,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Book an',
                      style: TextStyle(
                          color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w400)),
                  Text('Appointment',
                      style: TextStyle(
                          color: AppColors.textDark, fontSize: 22, fontWeight: FontWeight.w700)),
                ],
              ),
              background: Container(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(state.user.avatarUrl),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Category filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: 'All',
                          selected: _selectedCategory == null,
                          onTap: () => setState(() => _selectedCategory = null),
                        ),
                        const SizedBox(width: 10),
                        _CategoryChip(
                          label: 'Cardiologist',
                          selected: _selectedCategory == ServiceCategory.cardiologist,
                          onTap: () => setState(
                              () => _selectedCategory = ServiceCategory.cardiologist),
                        ),
                        const SizedBox(width: 10),
                        _CategoryChip(
                          label: 'Checkup',
                          selected: _selectedCategory == ServiceCategory.checkup,
                          onTap: () =>
                              setState(() => _selectedCategory = ServiceCategory.checkup),
                        ),
                        const SizedBox(width: 10),
                        _CategoryChip(
                          label: 'Test & Scan',
                          selected: _selectedCategory == ServiceCategory.testScan,
                          onTap: () =>
                              setState(() => _selectedCategory = ServiceCategory.testScan),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Featured appointment card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _FeaturedAppointmentCard(
                    service: AppData.services[0],
                    doctor: AppData.doctors[0],
                    onBook: () => _bookService(context, AppData.services[0], AppData.doctors[0]),
                  ),
                ),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Available Services',
                  actionLabel: 'Filter',
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: filtered
                        .skip(filtered.isNotEmpty ? 1 : 0)
                        .map((s) => ServiceTile(
                              service: s,
                              onBook: () => _bookService(context, s, null),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),
                // Top doctors section
                SectionHeader(
                  title: 'Available Doctors',
                  actionLabel: 'See All',
                  onAction: () => Navigator.pushNamed(context, '/doctors'),
                ),
                const SizedBox(height: 12),
                Column(
                  children: AppData.doctors.map((d) => DoctorCard(
                        doctor: d,
                        isFav: state.isFavorite(d),
                        onFav: () => state.toggleFavorite(d),
                        onTap: () => Navigator.pushNamed(context, '/doctor', arguments: d),
                      )).toList(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _bookService(BuildContext context, MedicalService service, Doctor? doctor) {
    final effectiveDoctor = doctor ?? AppData.doctors.first;
    Navigator.pushNamed(context, '/doctor', arguments: effectiveDoctor);
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: (0.3)), blurRadius: 8, offset: const Offset(0, 3))]
              : [BoxShadow(color: Colors.black.withValues(alpha: (0.05)), blurRadius: 4)],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMedium,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _FeaturedAppointmentCard extends StatelessWidget {
  final MedicalService service;
  final Doctor doctor;
  final VoidCallback onBook;

  const _FeaturedAppointmentCard({
    required this.service,
    required this.doctor,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: (0.35)),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: (0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cardiologist Appointment',
                        style: TextStyle(
                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined, color: Colors.white70, size: 12),
                        const SizedBox(width: 4),
                        Text(service.timeSlot,
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: (0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${service.slotsAvailable} Slots',
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 12),
          Row(
            children: [
              // Stacked avatars
              SizedBox(
                width: 80,
                height: 32,
                child: Stack(
                  children: AppData.doctors.take(3).toList().asMap().entries.map((e) {
                    return Positioned(
                      left: e.key * 22.0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(e.value.avatarUrl),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 6),
              Text('+${AppData.doctors.length} Doctors available',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              GestureDetector(
                onTap: onBook,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: AppColors.primary, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(doctor.avatarUrl),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(doctor.specialty,
                      style: const TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}