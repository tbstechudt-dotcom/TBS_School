import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _client;

  AuthNotifier(this._client) : super(const AsyncValue.data(null));

  Future<void> requestOtp({required String mobile}) async {
    state = const AsyncValue.loading();
    try {
      // Generate OTP and store in database
      final otp = _generateOtp();
      await _client.from('otp_verifications').insert({
        'mobile': mobile,
        'otp': otp,
        'purpose': 'signup',
        'expires_at':
            DateTime.now().add(const Duration(minutes: 10)).toIso8601String(),
      });

      // TODO: Send OTP via SMS gateway
      // For development, log the OTP
      // ignore: avoid_print
      print('OTP for $mobile: $otp');

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> verifyOtp({required String mobile, required String otp}) async {
    state = const AsyncValue.loading();
    try {
      final response = await _client
          .from('otp_verifications')
          .select()
          .eq('mobile', mobile)
          .eq('otp', otp)
          .eq('is_verified', false)
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        throw Exception('Invalid or expired OTP');
      }

      // Mark OTP as verified
      await _client
          .from('otp_verifications')
          .update({'is_verified': true}).eq('id', response['id']);

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUp(
      {required String mobile, required String password}) async {
    state = const AsyncValue.loading();
    try {
      // Create auth user with phone
      final authResponse = await _client.auth.signUp(
        phone: '+91$mobile',
        password: password,
      );

      if (authResponse.user == null) {
        throw Exception('Failed to create account');
      }

      // Create parent profile
      await _client.from('parents').insert({
        'id': authResponse.user!.id,
        'mobile': mobile,
        'is_verified': true,
      });

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signIn(
      {required String mobile, required String password}) async {
    state = const AsyncValue.loading();
    try {
      await _client.auth.signInWithPassword(
        phone: '+91$mobile',
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String _generateOtp() {
    // Generate 6-digit OTP
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(supabaseClientProvider));
});
