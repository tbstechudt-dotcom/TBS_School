import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/student_model.dart';
import 'auth_provider.dart' show supabaseClientProvider, parentAuthStateProvider;

/// Set to false to use Supabase data, true for dummy data
const bool useDummyData = false;

/// Currently selected student
final selectedStudentProvider = StateProvider<StudentModel?>((ref) => null);

/// Fetch students by parent ID (used after login)
final studentsByParentProvider = FutureProvider<List<StudentModel>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final parentAuthState = ref.watch(parentAuthStateProvider);

  final parent = parentAuthState.valueOrNull?.parent;
  if (parent == null) {
    return [];
  }

  try {
    final response = await client
        .from('students')
        .select('*')
        .eq('par_id', parent.parId)
        .eq('activestatus', 1)
        .order('stuname', ascending: true);

    return (response as List<dynamic>)
        .map((e) => StudentModel.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('Error fetching students by parent: $e');
    return [];
  }
});

/// Fetch all students from Supabase
final studentsProvider = FutureProvider<List<StudentModel>>((ref) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('students')
        .select('*')
        .eq('activestatus', 1)
        .order('stuname', ascending: true);

    return (response as List<dynamic>)
        .map((e) => StudentModel.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('Error fetching students: $e');
    return [];
  }
});

/// Fetch students by institution ID
final studentsByInstitutionProvider = FutureProvider.family<List<StudentModel>, int>((ref, insId) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('students')
        .select('*')
        .eq('ins_id', insId)
        .eq('activestatus', 1)
        .order('stuname', ascending: true);

    return (response as List<dynamic>)
        .map((e) => StudentModel.fromJson(e))
        .toList();
  } catch (e) {
    debugPrint('Error fetching students by institution: $e');
    return [];
  }
});

/// Fetch a single student by ID
final studentByIdProvider = FutureProvider.family<StudentModel?, int>((ref, stuId) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('students')
        .select('*')
        .eq('stu_id', stuId)
        .maybeSingle();

    if (response != null) {
      return StudentModel.fromJson(response);
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching student by ID: $e');
    return null;
  }
});

/// Fetch student by mobile number (for login)
final studentByMobileProvider = FutureProvider.family<StudentModel?, String>((ref, mobile) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('students')
        .select('*')
        .eq('stumobile', mobile)
        .eq('activestatus', 1)
        .maybeSingle();

    if (response != null) {
      return StudentModel.fromJson(response);
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching student by mobile: $e');
    return null;
  }
});

/// Fetch student by admission number
final studentByAdmissionProvider = FutureProvider.family<StudentModel?, String>((ref, admNo) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('students')
        .select('*')
        .eq('stuadmno', admNo)
        .eq('activestatus', 1)
        .maybeSingle();

    if (response != null) {
      return StudentModel.fromJson(response);
    }
    return null;
  } catch (e) {
    debugPrint('Error fetching student by admission number: $e');
    return null;
  }
});
