import 'package:flutter/material.dart';

import '../models/app_info.dart';
import '../services/app_selection_service.dart';
import '../services/apps_service.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  List<AppInfo> apps = [];
  List<AppInfo> filteredApps = [];

  bool loading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadApps();
  }

  Future<void> loadApps() async {
    final installedApps = await AppsService.instance.getInstalledApps();

    final selectedPackages = await AppSelectionService.instance
        .getSelectedApps();

    for (final app in installedApps) {
      app.selected = selectedPackages.contains(app.packageName);
    }

    installedApps.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    setState(() {
      apps = installedApps;
      filteredApps = List.from(installedApps);
      loading = false;
    });
  }

  void search(String value) {
    setState(() {
      filteredApps = apps.where((app) {
        return app.name.toLowerCase().contains(value.toLowerCase()) ||
            app.packageName.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> saveSelection() async {
    final selectedPackages = apps
        .where((e) => e.selected)
        .map((e) => e.packageName)
        .toList();

    await AppSelectionService.instance.saveSelectedApps(selectedPackages);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${selectedPackages.length} apps selected")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Apps")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveSelection,
        icon: const Icon(Icons.save),
        label: const Text("Save"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: searchController,
                    onChanged: search,
                    decoration: const InputDecoration(
                      hintText: "Search apps...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: filteredApps.length,
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];

                      return CheckboxListTile(
                        value: app.selected,
                        title: Text(app.name),
                        subtitle: Text(app.packageName),
                        onChanged: (value) {
                          setState(() {
                            app.selected = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
