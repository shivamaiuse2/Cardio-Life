import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../utils/app_state.dart';
import '../widgets/shared_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  final List<String> _recent = ['Cardiologist', 'ECG Test', 'Dr. James Anderson'];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final doctorResults = AppData.doctors
        .where((d) =>
            d.name.toLowerCase().contains(_query.toLowerCase()) ||
            d.specialty.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    final serviceResults = AppData.services
        .where((s) => s.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: TextField(
                        controller: _ctrl,
                        autofocus: true,
                        onChanged: (v) => setState(() => _query = v),
                        decoration: const InputDecoration(
                          hintText: 'Search doctors, tests, services...',
                          hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                          prefixIcon: Icon(Icons.search_rounded, color: AppColors.textLight),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _query.isEmpty
                  ? _buildSuggestions(context)
                  : _buildResults(context, doctorResults, serviceResults, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Recent Searches',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ..._recent.map((r) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history_rounded, color: AppColors.textLight),
              title: Text(r, style: const TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.north_west_rounded,
                  color: AppColors.textLight, size: 16),
              onTap: () {
                _ctrl.text = r;
                setState(() => _query = r);
              },
            )),
        const SizedBox(height: 20),
        const Text('Popular Searches',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['Echocardiogram', 'TMT Test', 'Heart Checkup', 'Blood Test',
            'Cardiologist Near Me'].map((t) => GestureDetector(
                onTap: () {
                  _ctrl.text = t;
                  setState(() => _query = t);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(t, style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
                ),
              )).toList(),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context, List<Doctor> doctors,
      List<MedicalService> services, AppState state) {
    if (doctors.isEmpty && services.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: AppColors.textLight.withOpacity(0.4)),
            const SizedBox(height: 12),
            const Text('No results found', style: TextStyle(color: AppColors.textLight)),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (doctors.isNotEmpty) ...[
          Text('Doctors (${doctors.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...doctors.map((d) => DoctorCard(
                doctor: d,
                isFav: state.isFavorite(d),
                onFav: () => state.toggleFavorite(d),
                onTap: () => Navigator.pushNamed(context, '/doctor', arguments: d),
              )),
        ],
        if (services.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Services (${services.length})',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...services.map((s) => ServiceTile(
                service: s,
                onBook: () => Navigator.pushNamed(context, '/doctor', arguments: AppData.doctors.first),
              )),
        ],
      ],
    );
  }
}