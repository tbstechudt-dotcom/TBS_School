import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/student_model.dart';
import '../../data/dummy_data.dart';
import 'auth_provider.dart';

/// Set to true to use dummy data instead of Supabase
const bool useDummyData = true;

final selectedStudentProvider = StateProvider<StudentModel?>((ref) => null);

final studentsProvider = FutureProvider<List<StudentModel>>((ref) async {
  // Use dummy data for development/testing
  if (useDummyData) {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return DummyData.students;
  }

  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) return [];

  final response = await client.from('parent_students').select('''
        student_id,
        students (
          id,
          school_id,
          class_id,
          admission_number,
          name,
          date_of_birth,
          gender,
          photo_url,
          is_active,
          classes (
            name,
            section
          )
        )
      ''').eq('parent_id', user.id);

  return (response as List<dynamic>)
      .map((e) => StudentModel.fromJson(e['students']))
      .toList();
});
