import 'package:flutter/material.dart';
import 'package:flutter_application_5/appointment/appointment_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final AppointmentService _service = AppointmentService();
  List<Map<String, dynamic>> appointments = [];
  final userId = Supabase.instance.client.auth.currentUser?.id ?? 'demo-user';

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final data = await _service.getAppointments(userId);
    setState(() {
      appointments = data;
    });
  }

  void _showForm({Map<String, dynamic>? appointment}) {
    final doctorController = TextEditingController(
      text: appointment?['doctor_name'] ?? '',
    );
    final dateController = TextEditingController(
      text: appointment?['date']?.toString() ?? '',
    );
    final timeController = TextEditingController(
      text: appointment?['time'] ?? '',
    );
    final reasonController = TextEditingController(
      text: appointment?['reason'] ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          appointment == null ? "Book Appointment" : "Update Appointment",
          style: const TextStyle(color: Colors.blue),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: doctorController,
                decoration: const InputDecoration(
                  labelText: "Doctor Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    dateController.text = picked.toIso8601String().split(
                      'T',
                    )[0];
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Time",
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    timeController.text = picked.format(context);
                  }
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () async {
              final doctorName = doctorController.text.trim();
              final dateText = dateController.text.trim();
              final time = timeController.text.trim();
              final reason = reasonController.text.trim();

              if (doctorName.isEmpty ||
                  dateText.isEmpty ||
                  time.isEmpty ||
                  reason.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              final date = DateTime.parse(dateText);

              if (appointment == null) {
                await _service.createAppointment(
                  userId: userId,
                  doctorName: doctorName,
                  date: date,
                  time: time,
                  reason: reason,
                );
              } else {
                await _service.updateAppointment(
                  appointmentId: appointment['id'] as int,
                  doctorName: doctorName,
                  date: date,
                  time: time,
                  reason: reason,
                );
              }

              Navigator.pop(context);
              _loadAppointments();
            },
            child: Text(appointment == null ? "Add" : "Update"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAppointment(int id) async {
    await _service.deleteAppointment(id);
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          "My Appointments",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: appointments.isEmpty
          ? const Center(
              child: Text(
                "No appointments yet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appt = appointments[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    title: Text(
                      appt['doctor_name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text("${appt['date']} | ${appt['time']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showForm(appointment: appt),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteAppointment(appt['id'] as int),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showForm(),
      ),
    );
  }
}
