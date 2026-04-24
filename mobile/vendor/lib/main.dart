import 'package:flutter/material.dart';
import 'package:shared/src/core/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ApiClient().initialize(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://10.0.2.2:54321'),
    supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'stub-key'),
  );

  runApp(const DhivashiVendorApp());
}

class DhivashiVendorApp extends StatelessWidget {
  const DhivashiVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhivashi - Vendor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const VendorDashboardScreen(),
    );
  }
}

class VendorDashboardScreen extends StatelessWidget {
  const VendorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fihhaara Terminal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Card(
            child: ListTile(
              title: Text('Pending Orderthah'),
              trailing: Text('14', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text('Inventory Sync (Hive)'),
              subtitle: Text('Last synced 5 mins ago'),
              trailing: Icon(Icons.sync),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ApiClient().syncOfflineData();
            },
            child: const Text('Force Sync with FastAPI'),
          )
        ],
      ),
    );
  }
}
