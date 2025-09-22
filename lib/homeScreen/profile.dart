import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

class ProfileInfoPage extends StatefulWidget {
  final Map<String, dynamic>? existingProfile;

  const ProfileInfoPage({super.key, this.existingProfile});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? gender;
  final List<String> genderOptions = ["Male", "Female"];

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    if (widget.existingProfile != null) {
      _nameController.text = widget.existingProfile!["name"] ?? "";
      _ageController.text = widget.existingProfile!["age"]?.toString() ?? "";
      gender = widget.existingProfile!["gender"];
      _phoneController.text = widget.existingProfile!["phone"] ?? "";
      _addressController.text = widget.existingProfile!["address"] ?? "";
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = supabase.auth.currentUser;
      debugPrint("Current user: ${supabase.auth.currentUser?.id}");

      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No logged in user")));
        return;
      }

      final profile = {
        'user_id': user.id,
        'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text) ?? 0,
        'gender': gender,
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await supabase
          .from('profiles')
          .upsert(profile, onConflict: 'user_id')
          .select();

      if (response.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              username: _nameController.text,
              age: int.tryParse(_ageController.text) ?? 0,
              gender: gender ?? "",
              phone: _phoneController.text,
              address: _addressController.text,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to save profile")));
      }
    } catch (e) {
      try {
        final user = supabase.auth.currentUser;
        if (user != null) {
          await supabase.from('profiles').insert({
            'user_id': user.id,
            'name': _nameController.text.trim(),
            'age': int.tryParse(_ageController.text) ?? 0,
            'gender': gender,
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      } catch (_) {}

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving profile: $e")));
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      _saveProfile();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProfile != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Profile" : "Complete Your Profile"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Name"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _ageController,
                  decoration: _inputDecoration("Age"),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Enter age";
                    if (int.tryParse(v) == null) return "Enter valid age";
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: _inputDecoration("Gender"),
                  items: genderOptions
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (val) => setState(() => gender = val),
                  validator: (v) => v == null ? "Select gender" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration("Phone Number"),
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      v == null || v.length < 7 ? "Enter valid phone" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _addressController,
                  decoration: _inputDecoration("Address"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Enter address" : null,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _continue,
                    child: Text(
                      isEditing ? "Update Profile" : "Save & Continue",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
