import 'package:flutter/material.dart';
import 'package:notification_forwarder/models/payment_notification.dart';
import 'package:notification_forwarder/screens/app_selection_screen.dart';
// import 'package:notification_forwarder/services/api_service.dart';
import 'package:notification_forwarder/services/notification_service.dart';
import 'package:notification_forwarder/services/permission_services.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final List<PaymentNotification> notifications = [];

  bool hasPermission = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkPermission();

    NotificationService.instance.notificationStream.listen((notification) {
      if (!mounted) return;

      setState(() {
        notifications.insert(0, notification);
      });
    });
  }

  Future<void> _checkPermission() async {
    final permission = await PermissionService.instance
        .isNotificationAccessEnabled();

    if (!mounted) return;

    setState(() {
      hasPermission = permission;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Forwarder"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppSelectionScreen()),
              );
            },
            child: const Text("Select Apps"),
          ),
          if (!hasPermission)
            ElevatedButton.icon(
              onPressed: () async {
                await PermissionService.instance.openNotificationSettings();
              },
              icon: const Icon(Icons.security),
              label: const Text("Grant Notification Access"),
            ),

          if (hasPermission)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "Notification Access Granted",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          Expanded(
            child: notifications.isEmpty
                ? const Center(
                    child: Text(
                      "Waiting for payment notifications...",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(item.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.text),
                              const SizedBox(height: 6),
                              Text(
                                item.packageName,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.timestamp.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
