/// Supabase configuration
class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase project URL
  /// Replace with your actual Supabase URL
  static const String url = 'https://your-project-id.supabase.co';

  /// Supabase anonymous key
  /// Replace with your actual Supabase anon key
  static const String anonKey = 'your-supabase-anon-key';

  /// Supabase service role key (for server-side operations only)
  /// Never expose this in client-side code
  static const String serviceRoleKey = '';
}
