import 'package:flutter/material.dart';
import 'package:flutter_application_5/homeScreen/appointment_page.dart';
import 'package:flutter_application_5/homeScreen/massage.dart';
import 'package:flutter_application_5/homeScreen/settings.dart';
import 'profilepage.dart';
import 'symptoms.dart';
import 'homevisit.dart';

class HomePage extends StatefulWidget {
  final String username;
  final int age;
  final String gender;
  final String phone;
  final String address;

  const HomePage({
    super.key,
    required this.username,
    required this.age,
    required this.gender,
    required this.phone,
    required this.address,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String? selectedSymptom;
  List<Map<String, dynamic>> homeVisitAppointments = [];

  Map<String, List<String>> symptomToSpecialty = {
    "Fever": ["General Surgeon", "Medicine", "Pediatrician"],
    "Cough": ["Pulmonologist", "ENT Specialist", "General Surgeon"],
    "Itching": ["Dermatologist"],
    "Headache": ["Neurologist", "Psychiatrist"],
    "Rashes": ["Dermatologist"],
    "Insomnia": ["Psychiatrist"],
    "Diarrhea": ["Medicine", "Pediatrician"],
    "Rabies": ["Medicine", "Neurologist"],
    "Typhoid": ["Medicine"],
    "Mumps": ["Pediatrician"],
    "Smallpox": ["Pediatrician", "Dermatologist"],
  };

  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Raisa Fakrul",
      "specialty": "Dermatologist",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Yeara",
      "specialty": "Cardiologist",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Maria Khan",
      "specialty": "Dermatologist",
      "image": "assets/pic4.jpg",
    },
    {
      "name": "Dr. Bondhon Das",
      "specialty": "Neurologist",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Anonna",
      "specialty": "Therapist",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Nurjahan",
      "specialty": "Medicine",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Arpon Roy",
      "specialty": "Therapist",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Laboni Hridi",
      "specialty": "Gynecologist",
      "image": "assets/pic4.jpg",
    },
    {
      "name": "Dr. Hasan Mahmud",
      "specialty": "Pediatrician",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Farzana Haque",
      "specialty": "Orthopedic",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Khalid Rahman",
      "specialty": "ENT Specialist",
      "image": "assets/pic4.jpg",
    },
    {
      "name": "Dr. Sabrina Jahan",
      "specialty": "Psychiatrist",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Tanvir Ahmed",
      "specialty": "General Surgeon",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Rukhsana Akter",
      "specialty": "Oncologist",
      "image": "assets/pic4.jpg",
    },
    {
      "name": "Dr. Mehedi Hasan",
      "specialty": "Urologist",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Samira Chowdhury",
      "specialty": "Endocrinologist",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Nayeem Islam",
      "specialty": "Ophthalmologist",
      "image": "assets/pic4.jpg",
    },
    {
      "name": "Dr. Tasnim Noor",
      "specialty": "Rheumatologist",
      "image": "assets/pic6.jpg",
    },
    {
      "name": "Dr. Rifat Hossain",
      "specialty": "Pulmonologist",
      "image": "assets/pic3.jpg",
    },
    {
      "name": "Dr. Jannatul Ferdous",
      "specialty": "Nephrologist",
      "image": "assets/pic6.jpg",
    },
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MessagePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredDoctors = selectedSymptom == null
        ? doctors
        : doctors.where((doc) {
            final specialtiesForSymptom =
                symptomToSpecialty[selectedSymptom!] ?? [];
            return specialtiesForSymptom.contains(doc["specialty"]);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hello ${widget.username}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyProfile(
                    name: widget.username,
                    age: widget.age,
                    gender: widget.gender,
                    phone: widget.phone,
                    address: widget.address,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AppointmentPage(),
                          ),
                        );
                      },
                      child: _buildOptionCard(
                        color: Colors.blue,
                        icon: Icons.add,
                        title: "Clinic Visit",
                        subtitle: "Make an appointment",
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final appointment = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeVisitPage(
                              name: widget.username,
                              phone: widget.phone,
                              address: widget.address,
                            ),
                          ),
                        );

                        if (appointment != null) {
                          setState(() {
                            homeVisitAppointments.add(appointment);
                          });
                        }
                      },

                      child: _buildOptionCard(
                        color: Colors.white,
                        icon: Icons.home,
                        title: "Home Visit",
                        subtitle: "Call the doctor home",
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Symptoms Section
              SymptomsSection(
                onSymptomsSelected: (symptom) {
                  setState(() {
                    selectedSymptom = symptom.isEmpty ? null : symptom;
                  });
                },
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedSymptom == null
                        ? "Best Doctor"
                        : "Doctors for $selectedSymptom",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "See More",
                    style: TextStyle(color: Colors.blue[700], fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              filteredDoctors.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No doctors available for this symptom."),
                      ),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(filteredDoctors.length, (index) {
                        final doctor = filteredDoctors[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AppointmentPage(),
                              ),
                            );
                          },
                          child: _buildDoctorCard(doctor),
                        );
                      }),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (color == Colors.white)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(doctor["image"], fit: BoxFit.cover),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor["name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  doctor["specialty"],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
