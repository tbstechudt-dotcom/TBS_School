import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/parent_model.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Custom auth state for parent-based authentication
class ParentAuthState {
  final ParentModel? parent;
  final bool isAuthenticated;

  ParentAuthState({
    this.parent,
    this.isAuthenticated = false,
  });

  ParentAuthState copyWith({
    ParentModel? parent,
    bool? isAuthenticated,
  }) {
    return ParentAuthState(
      parent: parent ?? this.parent,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Provider for parent authentication state
final parentAuthStateProvider =
    StateNotifierProvider<ParentAuthNotifier, AsyncValue<ParentAuthState>>(
        (ref) {
  return ParentAuthNotifier(ref.watch(supabaseClientProvider));
});

/// Legacy auth state provider - kept for compatibility
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});

/// Current logged-in parent provider
final currentParentProvider = Provider<ParentModel?>((ref) {
  final authState = ref.watch(parentAuthStateProvider);
  return authState.valueOrNull?.parent;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(supabaseClientProvider).auth.currentUser;
});

class ParentAuthNotifier extends StateNotifier<AsyncValue<ParentAuthState>> {
  final SupabaseClient _client;
  static const String _parentIdKey = 'logged_in_parent_id';

  ParentAuthNotifier(this._client)
      : super(AsyncValue.data(ParentAuthState())) {
    _loadSavedSession();
  }

  /// Load saved parent session from SharedPreferences
  Future<void> _loadSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedParentId = prefs.getInt(_parentIdKey);

      if (savedParentId != null) {
        // Fetch parent from database
        final response = await _client
            .from('parents')
            .select()
            .eq('par_id', savedParentId)
            .eq('activestatus', 1)
            .maybeSingle();

        if (response != null) {
          final parent = ParentModel.fromJson(response);
          state = AsyncValue.data(ParentAuthState(
            parent: parent,
            isAuthenticated: true,
          ));
        }
      }
    } catch (e) {
      // Silently fail - user will just need to login again
    }
  }

  /// Save parent session to SharedPreferences
  Future<void> _saveSession(int parentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_parentIdKey, parentId);
  }

  /// Clear saved session
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_parentIdKey);
  }

  /// Sign in using parent table - checks payinchargemob and parpassword
  Future<ParentModel> signIn({
    required String mobile,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      // Clean mobile number - remove any non-digit characters
      final cleanMobile = mobile.replaceAll(RegExp(r'[^0-9]'), '');

      // Query parents table for matching payinchargemob
      final response = await _client
          .from('parents')
          .select()
          .eq('payinchargemob', cleanMobile)
          .eq('activestatus', 1)
          .maybeSingle();

      if (response == null) {
        throw Exception('Mobile number not registered');
      }

      final parent = ParentModel.fromJson(response);

      // Verify password
      if (parent.parpassword != password) {
        throw Exception('Invalid password');
      }

      // Save session
      await _saveSession(parent.parId);

      state = AsyncValue.data(ParentAuthState(
        parent: parent,
        isAuthenticated: true,
      ));

      return parent;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Sign out - clear parent session
  Future<void> signOut() async {
    await _clearSession();
    state = AsyncValue.data(ParentAuthState());
  }

  /// Check if parent is authenticated
  bool get isAuthenticated => state.valueOrNull?.isAuthenticated ?? false;

  /// Get current parent
  ParentModel? get currentParent => state.valueOrNull?.parent;
}

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _client;
  final Ref _ref;

  AuthNotifier(this._client, this._ref) : super(const AsyncValue.data(null));

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

  Future<void> signUp({
    required String mobile,
    required String password,
  }) async {
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

  /// Sign in using parent table authentication
  Future<void> signIn({
    required String mobile,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Use parent table authentication
      await _ref.read(parentAuthStateProvider.notifier).signIn(
            mobile: mobile,
            password: password,
          );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _ref.read(parentAuthStateProvider.notifier).signOut();
    await _client.auth.signOut();
  }

  String _generateOtp() {
    // Generate 6-digit OTP
    return (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(supabaseClientProvider), ref);
});
