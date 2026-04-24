import 'package:flutter/material.dart';
import 'package:shared/src/core/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ApiClient().initialize(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://10.0.2.2:54321'),
    supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'stub-key'),
  );

  runApp(const DhivashiCustomerApp());
}

class DhivashiCustomerApp extends StatelessWidget {
  const DhivashiCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhivashi - Customer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CustomerHomeScreen(),
    );
  }
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fihhaara Explore (Mapbox Stub)'),
        actions: [
          // Tourism Mode Toggle Stub
          Switch(
            value: false,
            onChanged: (val) {},
            activeColor: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Text('Mapbox Map View\n(Offline Tile Caching Enabled)'),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Simulate offline-first order creation
                ApiClient().offlineBox.put('pending_orders', ['ORD-TEST-123']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order saved offline. Syncing when connected...')),
                );
              },
              child: const Text('Checkout (Hive Cache)'),
            ),
          )
        ],
      ),
    );
  }
}
