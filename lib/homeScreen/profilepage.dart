import 'package:flutter/material.dart';
import 'package:flutter_application_5/homeScreen/wellcome.dart';

class MyProfile extends StatefulWidget {
  final String name;
  final int age;
  final String gender;
  final String phone;
  final String address;

  const MyProfile({
    super.key,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
    required this.address,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late String currentGender;

  @override
  void initState() {
    super.initState();
    currentGender = widget.gender.toLowerCase() == 'male' ? 'male' : 'female';
  }

  void _toggleAvatar() {
    setState(() {
      currentGender = currentGender == 'male' ? 'female' : 'male';
    });
  }

  @override
  Widget build(BuildContext context) {
    Color avatarColor = currentGender == 'male' ? Colors.blue : Colors.pink;
    IconData avatarIcon = currentGender == 'male' ? Icons.male : Icons.female;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleAvatar,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: avatarColor.withOpacity(0.2),
                    child: Icon(avatarIcon, color: avatarColor, size: 50),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Tap avatar to switch male/female",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.blue),
                    title: Text(
                      widget.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text("Full Name"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.cake, color: Colors.blue),
                    title: Text(
                      "${widget.age}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text("Age"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.wc, color: Colors.blue),
                    title: Text(
                      widget.gender,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text("Gender"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: Text(
                      widget.phone,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text("Phone Number"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.home, color: Colors.blue),
                    title: Text(
                      widget.address,
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text("Address"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
