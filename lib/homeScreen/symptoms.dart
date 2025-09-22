import 'package:flutter/material.dart';

class SymptomsSection extends StatefulWidget {
  final Function(String) onSymptomsSelected;

  const SymptomsSection({super.key, required this.onSymptomsSelected});

  @override
  State<SymptomsSection> createState() => _SymptomsSectionState();
}

class _SymptomsSectionState extends State<SymptomsSection> {
  String? selectedSymptom;

  final List<String> symptomsList = [
    "Fever",
    "Cough",
    "Itching",
    "Headache",
    "Rashes",
    "Insomnia",
    "Diarrhea",
    "Rabies",
    "Typhoid",
    "Mumps",
    "Smallpox",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Your Symptoms",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: symptomsList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final symptom = symptomsList[index];
              final isSelected = selectedSymptom == symptom;
              return FilterChip(
                label: Text(
                  symptom,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedSymptom = selected ? symptom : null;
                    widget.onSymptomsSelected(selectedSymptom ?? '');
                  });
                },
                selectedColor: Colors.blue,
                backgroundColor: Colors.blue.shade50,
                checkmarkColor: Colors.white,
              );
            },
          ),
        ),
      ],
    );
  }
}
