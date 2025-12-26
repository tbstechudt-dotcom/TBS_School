import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/notification_model.dart';
import '../../data/dummy_data.dart';
import 'auth_provider.dart';
import 'student_provider.dart';

final notificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  // Use dummy data for development/testing
  if (useDummyData) {
    await Future.delayed(const Duration(milliseconds: 300));
    return DummyData.getNotifications();
  }

  final client = ref.watch(supabaseClientProvider);
  final user = ref.watch(currentUserProvider);

  if (user == null) return [];

  final response = await client
      .from('notifications')
      .select()
      .eq('parent_id', user.id)
      .order('created_at', ascending: false);

  return (response as List<dynamic>)
      .map((e) => NotificationModel.fromJson(e))
      .toList();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final SupabaseClient _client;
  final Ref _ref;

  NotificationNotifier(this._client, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> markAsRead(String notificationId) async {
    state = const AsyncValue.loading();
    try {
      await _client.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId);

      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) return;

      await _client
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('parent_id', user.id)
          .eq('is_read', false);

      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final notificationActionsProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
  return NotificationNotifier(
    ref.watch(supabaseClientProvider),
    ref,
  );
});
