import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:math' as math;

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_canvas.dart';
import '../../../core/services/local_db_service.dart';

class ActionHubScreen extends ConsumerStatefulWidget {
  const ActionHubScreen({super.key});

  @override
  ConsumerState<ActionHubScreen> createState() => _ActionHubScreenState();
}

class _ActionHubScreenState extends ConsumerState<ActionHubScreen> with TickerProviderStateMixin {
  bool _isDeploying = false;
  bool _isDeployed = false;
  late AnimationController _pulseController;
  late AnimationController _rocketController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _rocketController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rocketController.dispose();
    super.dispose();
  }

  void _startDeployment() async {
    setState(() => _isDeploying = true);
    _pulseController.repeat(reverse: true);
    _rocketController.forward();
    
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      _pulseController.stop();
      setState(() {
        _isDeploying = false;
        _isDeployed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeploying || _isDeployed) {
      return _buildDeploymentScreen();
    }

    final dbService = ref.watch(localDbProvider);

    return GlowingCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Action Hub Simulation'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: dbService.getCampaigns(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final configString = snapshot.data?.isNotEmpty == true ? snapshot.data!.last['generated_config'] as String? : null;
            Map<String, dynamic> config = {};
            if (configString != null && configString.isNotEmpty) {
              try {
                final cleanStr = configString.replaceAll(RegExp(r'```json|```'), '').trim();
                config = jsonDecode(cleanStr);
              } catch (e) {
                config = {"Status": "Raw Output", "Details": configString};
              }
            } else {
              config = {
                "exclude_regions": "Lahore, Karachi",
                "new_target_cpa": "\$1.20",
                "budget_allocation": "Shift 30% to Islamabad",
                "ad_copy_adjustment": "Focus on high-quality leads"
              };
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Simulated Actions',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: config.entries.map((e) {
                        return _buildActionBox(context, e.key, e.value.toString());
                      }).toList(),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.electricIndigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 10,
                      shadowColor: AppTheme.electricIndigo.withValues(alpha: 0.5),
                    ),
                    icon: const Icon(Icons.rocket_launch, size: 24),
                    label: const Text("Deploy to Ads Manager", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    onPressed: _startDeployment,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeploymentScreen() {
    return GlowingCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: _isDeployed ? _buildSuccessState() : _buildAnimatingState(),
        ),
      ),
    );
  }

  Widget _buildAnimatingState() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150 + (_pulseController.value * 50),
                  height: 150 + (_pulseController.value * 50),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.electricIndigo.withValues(alpha: 0.2),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.electricIndigo,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.electricIndigo.withValues(alpha: 0.8),
                        blurRadius: 30 * _pulseController.value,
                        spreadRadius: 10 * _pulseController.value,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _rocketController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -200 * _rocketController.value),
                        child: const Icon(Icons.rocket_launch, size: 60, color: Colors.white),
                      );
                    }
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Deploying Configuration...",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Syncing with Meta Ads API",
              style: TextStyle(color: AppTheme.dimmedAlloyGrey, fontSize: 16),
            ),
          ],
        );
      }
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.greenAccent.withValues(alpha: 0.2),
            border: Border.all(color: Colors.greenAccent, width: 4),
          ),
          child: const Icon(Icons.check_rounded, size: 80, color: Colors.greenAccent),
        ),
        const SizedBox(height: 40),
        const Text(
          "Deployed to Ads Manager!",
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          "All regional anomalies have been mitigated.",
          style: TextStyle(color: AppTheme.dimmedAlloyGrey, fontSize: 16),
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.white24),
              ),
            ),
            icon: const Icon(Icons.home),
            label: const Text("Return to Dashboard", style: TextStyle(fontSize: 18)),
            onPressed: () => context.go('/'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBox(BuildContext context, String key, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSlateGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.electricIndigo.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppTheme.electricIndigo),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key.toUpperCase().replaceAll('_', ' '),
                  style: const TextStyle(
                    color: AppTheme.dimmedAlloyGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.pearlWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
