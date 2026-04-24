import 'package:flutter/material.dart';
import 'package:shared/src/core/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ApiClient().initialize(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL', defaultValue: 'http://10.0.2.2:54321'),
    supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'stub-key'),
  );

  runApp(const DhivashiRiderApp());
}

class DhivashiRiderApp extends StatelessWidget {
  const DhivashiRiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhivashi - Rider',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const RiderHomeScreen(),
    );
  }
}

class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery (Gigs)'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status: Active', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Today: MVR 450 (80% Comm.)', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Mapbox GPS Route View Stub'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           // Simulate calling FastAPI GET /delivery/available
        },
        label: const Text('Find Gigs'),
        icon: const Icon(Icons.search),
      ),
    );
  }
}
