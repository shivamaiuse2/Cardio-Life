import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  int _currentIndex = 0;
  final List<Appointment> _appointments = List.from(AppData.appointments);
  final UserProfile _user = AppData.currentUser;
  final List<Doctor> _favorites = [];

  int get currentIndex => _currentIndex;
  List<Appointment> get appointments => _appointments;
  UserProfile get user => _user;
  List<Doctor> get favorites => _favorites;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void addAppointment(Appointment appointment) {
    _appointments.insert(0, appointment);
    notifyListeners();
  }

  void cancelAppointment(String id) {
    final idx = _appointments.indexWhere((a) => a.id == id);
    if (idx != -1) {
      final old = _appointments[idx];
      _appointments[idx] = Appointment(
        id: old.id,
        doctor: old.doctor,
        date: old.date,
        timeSlot: old.timeSlot,
        status: AppointmentStatus.cancelled,
        type: old.type,
        notes: old.notes,
        appointmentId: old.appointmentId,
      );
      notifyListeners();
    }
  }

  bool isFavorite(Doctor doctor) => _favorites.any((d) => d.id == doctor.id);

  void toggleFavorite(Doctor doctor) {
    if (isFavorite(doctor)) {
      _favorites.removeWhere((d) => d.id == doctor.id);
    } else {
      _favorites.add(doctor);
    }
    notifyListeners();
  }
}