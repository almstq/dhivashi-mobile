import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late final SupabaseClient supabase;
  late final Box offlineBox;

  Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    // 1. Initialize Hive for Offline-First Data
    await Hive.initFlutter();
    offlineBox = await Hive.openBox('dhivashi_offline_cache');

    // 2. Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    supabase = Supabase.instance.client;
  }

  // Auth helper with +960 default
  Future<void> loginWithPhone(String phone) async {
    final formattedPhone = phone.startsWith('+960') ? phone : '+960$phone';
    await supabase.auth.signInWithOtp(phone: formattedPhone);
  }

  // Fast API proxy stub (e.g. for /orders or /delivery)
  Future<void> syncOfflineData() async {
    final pendingOrders = offlineBox.get('pending_orders', defaultValue: []);
    if (pendingOrders.isNotEmpty) {
      // Logic to sync with FastAPI backend when online
      print('Syncing \${pendingOrders.length} offline orders with FastAPI...');
      // Clear cache after successful sync
      await offlineBox.put('pending_orders', []);
    }
  }
}
