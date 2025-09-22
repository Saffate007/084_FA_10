import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentService {
  final _table = Supabase.instance.client.from('appointment'); // fix table name

  // CREATE
  Future<void> createAppointment({
    required String userId,
    required String doctorName,
    required DateTime date,
    required String time,
    required String reason,
  }) async {
    await _table.insert({
      'user_id': userId,
      'doctor_name': doctorName,
      'date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'time': time,
      'reason': reason,
    });
  }

  // READ
  Future<List<Map<String, dynamic>>> getAppointments(String userId) async {
    final response = await _table
        .select()
        .eq('user_id', userId)
        .order('date', ascending: true);

    return List<Map<String, dynamic>>.from(
      response.map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  // UPDATE
  Future<void> updateAppointment({
    required int appointmentId,
    required String doctorName,
    required DateTime date,
    required String time,
    required String reason,
  }) async {
    await _table
        .update({
          'doctor_name': doctorName,
          'date': date.toIso8601String().split('T')[0],
          'time': time,
          'reason': reason,
        })
        .eq('id', appointmentId);
  }

  // DELETE
  Future<void> deleteAppointment(int appointmentId) async {
    await _table.delete().eq('id', appointmentId);
  }
}
