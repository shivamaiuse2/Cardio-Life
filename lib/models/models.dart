// ─── Doctor Model ────────────────────────────────────────────────────────────
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String qualification;
  final double rating;
  final int reviewCount;
  final int experience;
  final String hospital;
  final String avatarUrl;
  final bool isAvailable;
  final double consultationFee;
  final List<String> availableDays;
  final List<String> availableSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualification,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.hospital,
    required this.avatarUrl,
    required this.isAvailable,
    required this.consultationFee,
    required this.availableDays,
    required this.availableSlots,
  });
}

// ─── Appointment Model ────────────────────────────────────────────────────────
class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final AppointmentType type;
  final String? notes;
  final String appointmentId;

  Appointment({
    required this.id,
    required this.doctor,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.type,
    this.notes,
    required this.appointmentId,
  });
}

enum AppointmentStatus { confirmed, pending, cancelled, completed }

enum AppointmentType { initialConsultation, followUp, checkup, testScan }

// ─── Service/Test Model ───────────────────────────────────────────────────────
class MedicalService {
  final String id;
  final String name;
  final String center;
  final String timeSlot;
  final int slotsAvailable;
  final String iconPath;
  final double price;
  final ServiceCategory category;

  MedicalService({
    required this.id,
    required this.name,
    required this.center,
    required this.timeSlot,
    required this.slotsAvailable,
    required this.iconPath,
    required this.price,
    required this.category,
  });
}

enum ServiceCategory { cardiologist, checkup, testScan }

// ─── Health Metric Model ──────────────────────────────────────────────────────
class HealthMetric {
  final String name;
  final String value;
  final String unit;
  final String status;
  final List<double> weeklyData;

  HealthMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.weeklyData,
  });
}

// ─── User Model ───────────────────────────────────────────────────────────────
class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final int age;
  final String bloodGroup;
  final double height;
  final double weight;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.age,
    required this.bloodGroup,
    required this.height,
    required this.weight,
  });
}

// ─── Sample Data ──────────────────────────────────────────────────────────────
class AppData {
  static final UserProfile currentUser = UserProfile(
    name: 'Alex Morgan',
    email: 'alex.morgan@email.com',
    phone: '+1 234 567 8900',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    age: 34,
    bloodGroup: 'O+',
    height: 175,
    weight: 72,
  );

  static final List<Doctor> doctors = [
    Doctor(
      id: 'd1',
      name: 'Dr. James Anderson',
      specialty: 'Senior Cardiologist',
      qualification: 'MD, FACC',
      rating: 4.9,
      reviewCount: 312,
      experience: 15,
      hospital: 'Heart Care Medical Center',
      avatarUrl: 'https://i.pravatar.cc/150?img=57',
      isAvailable: true,
      consultationFee: 150,
      availableDays: ['Mon', 'Wed', 'Fri'],
      availableSlots: ['09:00 AM', '10:00 AM', '11:00 AM', '02:00 PM', '03:00 PM'],
    ),
    Doctor(
      id: 'd2',
      name: 'Dr. Sarah Williams',
      specialty: 'Interventional Cardiologist',
      qualification: 'MD, PhD',
      rating: 4.8,
      reviewCount: 287,
      experience: 12,
      hospital: 'Cardiac Wellness Center',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      isAvailable: true,
      consultationFee: 180,
      availableDays: ['Tue', 'Thu', 'Sat'],
      availableSlots: ['10:00 AM', '11:30 AM', '01:00 PM', '04:00 PM'],
    ),
    Doctor(
      id: 'd3',
      name: 'Dr. Michael Chen',
      specialty: 'Electrophysiologist',
      qualification: 'MD, FHRS',
      rating: 4.7,
      reviewCount: 198,
      experience: 10,
      hospital: 'Cardiac Diagnostic Center',
      avatarUrl: 'https://i.pravatar.cc/150?img=53',
      isAvailable: false,
      consultationFee: 200,
      availableDays: ['Mon', 'Tue', 'Thu'],
      availableSlots: ['09:30 AM', '11:00 AM', '02:30 PM'],
    ),
    Doctor(
      id: 'd4',
      name: 'Dr. Emily Roberts',
      specialty: 'Pediatric Cardiologist',
      qualification: 'MD, FAAP',
      rating: 4.9,
      reviewCount: 156,
      experience: 8,
      hospital: 'Children\'s Heart Institute',
      avatarUrl: 'https://i.pravatar.cc/150?img=44',
      isAvailable: true,
      consultationFee: 160,
      availableDays: ['Mon', 'Wed', 'Fri', 'Sat'],
      availableSlots: ['10:00 AM', '11:00 AM', '01:00 PM', '03:00 PM'],
    ),
  ];

  static final List<MedicalService> services = [
    MedicalService(
      id: 's1',
      name: 'Cardiologist Appointment',
      center: 'Dr. James Anderson',
      timeSlot: '10:00 - 10:30 AM',
      slotsAvailable: 3,
      iconPath: 'heart',
      price: 150,
      category: ServiceCategory.cardiologist,
    ),
    MedicalService(
      id: 's2',
      name: 'Echocardiogram',
      center: 'Cardiac Diagnostic Center',
      timeSlot: '11:30 - 12:00 PM',
      slotsAvailable: 2,
      iconPath: 'echo',
      price: 250,
      category: ServiceCategory.testScan,
    ),
    MedicalService(
      id: 's3',
      name: 'TMT (Stress Test)',
      center: 'Cardiac Wellness Center',
      timeSlot: '02:00 - 02:30 PM',
      slotsAvailable: 2,
      iconPath: 'tmt',
      price: 200,
      category: ServiceCategory.testScan,
    ),
    MedicalService(
      id: 's4',
      name: 'Full Body Checkup',
      center: 'Heart Care Medical Center',
      timeSlot: '09:00 - 10:00 AM',
      slotsAvailable: 5,
      iconPath: 'checkup',
      price: 300,
      category: ServiceCategory.checkup,
    ),
    MedicalService(
      id: 's5',
      name: 'Blood Test & Panel',
      center: 'Cardiac Diagnostic Center',
      timeSlot: '08:00 - 09:00 AM',
      slotsAvailable: 8,
      iconPath: 'blood',
      price: 80,
      category: ServiceCategory.checkup,
    ),
  ];

  static final List<Appointment> appointments = [
    Appointment(
      id: 'a1',
      doctor: doctors[0],
      date: DateTime(2025, 5, 16, 10, 0),
      timeSlot: '10:00 - 10:30 AM',
      status: AppointmentStatus.confirmed,
      type: AppointmentType.initialConsultation,
      appointmentId: 'CLM789456',
      notes: 'Bring previous ECG reports',
    ),
    Appointment(
      id: 'a2',
      doctor: doctors[1],
      date: DateTime(2025, 5, 20, 11, 30),
      timeSlot: '11:30 - 12:00 PM',
      status: AppointmentStatus.pending,
      type: AppointmentType.followUp,
      appointmentId: 'CLM789457',
    ),
    Appointment(
      id: 'a3',
      doctor: doctors[2],
      date: DateTime(2025, 4, 10, 9, 0),
      timeSlot: '09:00 - 09:30 AM',
      status: AppointmentStatus.completed,
      type: AppointmentType.checkup,
      appointmentId: 'CLM789300',
    ),
  ];

  static final List<HealthMetric> healthMetrics = [
    HealthMetric(
      name: 'Heart Rate',
      value: '72',
      unit: 'bpm',
      status: 'Normal',
      weeklyData: [68, 72, 75, 70, 73, 71, 72],
    ),
    HealthMetric(
      name: 'Blood Pressure',
      value: '120/80',
      unit: 'mmHg',
      status: 'Normal',
      weeklyData: [118, 122, 120, 119, 121, 120, 120],
    ),
    HealthMetric(
      name: 'Blood Oxygen',
      value: '98',
      unit: '%',
      status: 'Excellent',
      weeklyData: [97, 98, 99, 98, 97, 98, 98],
    ),
    HealthMetric(
      name: 'Cholesterol',
      value: '185',
      unit: 'mg/dL',
      status: 'Optimal',
      weeklyData: [190, 188, 186, 185, 184, 185, 185],
    ),
  ];
}