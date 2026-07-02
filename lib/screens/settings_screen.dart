import 'package:flutter/material.dart';
import '../services/native_settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderEmailController = TextEditingController();
  final _recipientEmailController = TextEditingController();

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    _apiKeyController.text = await NativeSettingsService.instance
        .getBrevoApiKey();

    _senderNameController.text = await NativeSettingsService.instance
        .getSenderName();

    _senderEmailController.text = await NativeSettingsService.instance
        .getSenderEmail();

    _recipientEmailController.text = await NativeSettingsService.instance
        .getRecipientEmail();

    setState(() {
      loading = false;
    });
  }

  Future<void> saveSettings() async {
    if (_apiKeyController.text.trim().isEmpty) {
      _showSnackBar("Brevo API Key is required");
      return;
    }

    if (_senderNameController.text.trim().isEmpty) {
      _showSnackBar("Sender Name is required");
      return;
    }

    if (_senderEmailController.text.trim().isEmpty) {
      _showSnackBar("Sender Email is required");
      return;
    }

    if (_recipientEmailController.text.trim().isEmpty) {
      _showSnackBar("Recipient Email is required");
      return;
    }

    setState(() {
      saving = true;
    });

    await NativeSettingsService.instance.saveBrevoApiKey(
      _apiKeyController.text.trim(),
    );

    await NativeSettingsService.instance.saveSenderName(
      _senderNameController.text.trim(),
    );

    await NativeSettingsService.instance.saveSenderEmail(
      _senderEmailController.text.trim(),
    );

    await NativeSettingsService.instance.saveRecipientEmail(
      _recipientEmailController.text.trim(),
    );

    setState(() {
      saving = false;
    });

    _showSnackBar("Settings saved successfully.");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _senderNameController.dispose();
    _senderEmailController.dispose();
    _recipientEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Brevo Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Brevo API Key",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _senderNameController,
              decoration: const InputDecoration(
                labelText: "Sender Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _senderEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Verified Sender Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _recipientEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Recipient Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: saving ? null : saveSettings,
                icon: saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: Text(saving ? "Saving..." : "Save Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
