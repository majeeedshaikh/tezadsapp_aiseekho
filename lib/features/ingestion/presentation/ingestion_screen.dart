import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../../../core/theme/app_theme.dart';
import '../../../core/services/csv_parser_isolate.dart';
import '../../agent_trace/application/agent_workflow_controller.dart';

class IngestionScreen extends ConsumerStatefulWidget {
  const IngestionScreen({super.key});

  @override
  ConsumerState<IngestionScreen> createState() => _IngestionScreenState();
}

class _IngestionScreenState extends ConsumerState<IngestionScreen> {
  final TextEditingController _promptController = TextEditingController();
  String? _selectedFilePath;

  void _submit() async {
    final prompt = _promptController.text.trim().isEmpty 
        ? "Fix the high CPC and revenue drop in Lahore." 
        : _promptController.text;
    
    // For demo purposes, we will load the sample CSV regardless, 
    // to guarantee the AI engine processes correctly for the hackathon.
    final csvString = await rootBundle.loadString('assets/samples/regional_retail_drops.csv');
    final parsedData = await CsvParserService.parseCsvInBackground(csvString);
    
    ref.read(agentWorkflowControllerProvider.notifier).runPipeline(parsedData, prompt);

    if (mounted) {
      context.go('/trace');
    }
  }

  void _pickFile() async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkSlateGrey,
          title: const Text('Internal Storage', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.folder, color: AppTheme.electricIndigo),
                  title: const Text('Downloads', style: TextStyle(color: Colors.white)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.white70),
                  title: const Text('q1_ad_metrics.csv', style: TextStyle(color: Colors.white70)),
                  subtitle: const Text('1.2 MB • Today', style: TextStyle(color: Colors.white38)),
                  onTap: () => Navigator.pop(context, 'q1_ad_metrics.csv'),
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                  title: const Text('marketing_brief.pdf', style: TextStyle(color: Colors.white70)),
                  subtitle: const Text('4.5 MB • Yesterday', style: TextStyle(color: Colors.white38)),
                  onTap: () => Navigator.pop(context, 'marketing_brief.pdf'),
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file, color: Colors.white70),
                  title: const Text('regional_retail_drops.csv', style: TextStyle(color: Colors.white70)),
                  subtitle: const Text('850 KB • Last Week', style: TextStyle(color: Colors.white38)),
                  onTap: () => Navigator.pop(context, 'regional_retail_drops.csv'),
                ),
              ],
            ),
          ),
        );
      }
    );

    if (result != null) {
      _showFilePreview(result);
    }
  }

  void _showFilePreview(String fileName) async {
    String content = "Loading preview...";
    if (fileName == 'regional_retail_drops.csv') {
      content = await rootBundle.loadString('assets/samples/regional_retail_drops.csv');
    } else if (fileName == 'marketing_brief.pdf') {
      content = "[PDF File Metadata]\nTitle: Q1 2026 Marketing Brief\nPages: 12\n\nSummary:\nThis document outlines the strategic advertising allocation for Q1, focusing on expanding the user base in the Punjab region. Target CPA is \$15.00.";
    } else {
      content = "Region,Date,AdSpend,Clicks\nLahore,2026-01-01,100,50\nKarachi,2026-01-01,200,120\nIslamabad,2026-01-01,150,90";
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkSlateGrey,
          title: Text('Preview: $fileName', style: const TextStyle(color: Colors.white)),
          content: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              child: Text(content, style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace')),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.electricIndigo),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedFilePath = fileName;
                  _promptController.text = "Analyze my newly uploaded file: $fileName";
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('File attached: $fileName')),
                );
              },
              child: const Text('Attach', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }
    );
  }

  void _showProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSlateGrey,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(radius: 40, backgroundColor: AppTheme.electricIndigo, child: Icon(Icons.person, size: 40, color: Colors.white)),
                const SizedBox(height: 16),
                const Text('Muhammad', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Admin Account', style: TextStyle(color: Colors.white54, fontSize: 16)),
                const SizedBox(height: 32),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text('Account Settings', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsMock('Account Settings', 'Settings are locked during the active Hackathon simulation to preserve demo integrity.');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.vpn_key, color: Colors.white),
                  title: const Text('API Keys (Meta & Google)', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsMock('API Keys', 'API Key management is locked for the demo.');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.white),
                  title: const Text('Notification Preferences', style: TextStyle(color: Colors.white)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                  onTap: () {
                    Navigator.pop(context);
                    _showSettingsMock('Notification Preferences', 'Notifications configuration is unavailable in demo mode.');
                  },
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  void _showSettingsMock(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSlateGrey,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK', style: TextStyle(color: AppTheme.electricIndigo)))
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.onyxBlack,
      drawer: Drawer(
        backgroundColor: AppTheme.onyxBlack,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.darkSlateGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/logos/whitelogo.png', height: 80),
                  const SizedBox(height: 16),
                  const Text('TezAds Workspace', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: AppTheme.electricIndigo),
              title: const Text('Chat Console', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.campaign, color: Colors.white54),
              title: const Text('Campaigns', style: TextStyle(color: Colors.white54)),
              onTap: () {
                Navigator.pop(context);
                context.push('/campaigns');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.white54),
              title: const Text('Audiences', style: TextStyle(color: Colors.white54)),
              onTap: () {
                Navigator.pop(context);
                _showSettingsMock('Audiences', 'Mock Audience data is currently loading. (Hackathon Demo)');
              },
            ),
            ListTile(
              leading: const Icon(Icons.image, color: Colors.white54),
              title: const Text('Creatives', style: TextStyle(color: Colors.white54)),
              onTap: () {
                Navigator.pop(context);
                _showSettingsMock('Creatives Library', 'Creative assets repository is locked for this demo.');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.white54),
              title: const Text('Billing', style: TextStyle(color: Colors.white54)),
              onTap: () {
                Navigator.pop(context);
                _showSettingsMock('Billing & Payments', 'Billing module is restricted in the sandbox environment.');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  Image.asset('assets/logos/whitelogo.png', height: 80),
                  GestureDetector(
                    onTap: _showProfile,
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.electricIndigo,
                      child: Icon(Icons.person, size: 22, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hi Muhammad,',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'What\'s on your mind?',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 28,
                          color: AppTheme.dimmedAlloyGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: AppTheme.darkSlateGrey,
                borderRadius: BorderRadius.circular(32.0),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _selectedFilePath != null ? Icons.attach_file : Icons.add, 
                      color: _selectedFilePath != null ? AppTheme.electricIndigo : AppTheme.dimmedAlloyGrey
                    ),
                    onPressed: _pickFile,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      style: const TextStyle(color: AppTheme.pearlWhite),
                      minLines: 1,
                      maxLines: 6,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        hintText: 'Ask TezAds or Add Data...',
                        hintStyle: TextStyle(color: AppTheme.dimmedAlloyGrey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppTheme.electricIndigo),
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
