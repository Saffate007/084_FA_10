import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeVisitPage extends StatefulWidget {
  final String name;
  final String phone;
  final String address;

  const HomeVisitPage({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<HomeVisitPage> createState() => _HomeVisitPageState();
}

class _HomeVisitPageState extends State<HomeVisitPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> myAppointments = [];

  final List<String> doctors = [
    "Dr. Ayesha Rahman",
    "Dr. Shafiqul Islam",
    "Dr. Tanvir Ahmed",
    "Dr. Nusrat Jahan",
    "Dr. Imran Hossain",
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);

    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final response = await supabase
          .from("appointments")
          .select()
          .eq("phone", widget.phone);

      setState(() {
        myAppointments = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint("Error fetching appointments: $e");
    }
  }

  Future<void> _bookHomeVisit() async {
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final notes = _notesController.text.trim();

    if (date.isEmpty || time.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill date and time")),
      );
      return;
    }

    final doctor = doctors[Random().nextInt(doctors.length)];

    final appointment = {
      "name": _nameController.text,
      "phone": _phoneController.text,
      "address": _addressController.text,
      "date": date,
      "time": time,
      "notes": notes,
      "doctor": doctor,
    };

    try {
      final response = await supabase
          .from("appointments")
          .insert(appointment)
          .select();

      setState(() {
        myAppointments.add(response.first);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Home visit booked with $doctor")));

      _dateController.clear();
      _timeController.clear();
      _notesController.clear();
    } catch (e) {
      debugPrint("Error booking appointment: $e");
    }
  }

  Future<void> _deleteAppointment(int id) async {
    try {
      await supabase.from("appointments").delete().eq("id", id);

      setState(() {
        myAppointments.removeWhere((appt) => appt["id"] == id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Appointment deleted")));
    } catch (e) {
      debugPrint("Error deleting appointment: $e");
    }
  }

  void _showAppointments() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "My Home Visit Appointments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (myAppointments.isEmpty)
                const Text("No appointments booked yet."),
              ...myAppointments.map(
                (appt) => ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text("${appt['date']} at ${appt['time']}"),
                  subtitle: Text(
                    "${appt['doctor']} • ${appt['name']} • ${appt['phone']}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteAppointment(appt["id"]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Visit Appointment"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "Preferred Date",
                  border: OutlineInputBorder(),
                  hintText: "YYYY-MM-DD",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: "Preferred Time",
                  border: OutlineInputBorder(),
                  hintText: "HH:MM",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Special Instructions",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _bookHomeVisit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Book Home Visit"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAppointments,
        backgroundColor: Colors.blue,
        label: const Text("Visit Appointments"),
        icon: const Icon(Icons.list_alt),
      ),
    );
  }
}
