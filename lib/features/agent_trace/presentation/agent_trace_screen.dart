import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_canvas.dart';
import '../application/agent_workflow_controller.dart';

class AgentTraceScreen extends ConsumerStatefulWidget {
  const AgentTraceScreen({super.key});

  @override
  ConsumerState<AgentTraceScreen> createState() => _AgentTraceScreenState();
}

class _AgentTraceScreenState extends ConsumerState<AgentTraceScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _nodeControllers;

  final List<Map<String, dynamic>> _agentConfig = [
    {"icon": Icons.cloud_download_outlined, "name": "Data Ingestion", "color": Colors.blueAccent},
    {"icon": Icons.troubleshoot, "name": "Diagnostic AI", "color": Colors.orangeAccent},
    {"icon": Icons.psychology, "name": "Strategy Planner", "color": Colors.purpleAccent},
    {"icon": Icons.gavel, "name": "Safety & Compliance", "color": Colors.greenAccent},
    {"icon": Icons.schema, "name": "Execution Bridge", "color": AppTheme.electricIndigo},
  ];

  @override
  void initState() {
    super.initState();
    _nodeControllers = List.generate(
      5,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _nodeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(agentWorkflowControllerProvider);

    // Update animation states based on currentAgentIndex
    for (int i = 0; i < 5; i++) {
      if (state.currentAgentIndex == i) {
        if (!_nodeControllers[i].isAnimating) _nodeControllers[i].repeat(reverse: true);
      } else {
        _nodeControllers[i].stop();
        _nodeControllers[i].value = 0;
      }
    }

    return GlowingCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Agentic Network', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                itemCount: _agentConfig.length,
                itemBuilder: (context, index) {
                  final isActive = state.currentAgentIndex == index;
                  final isPast = state.currentAgentIndex > index || state.isCompleted;
                  
                  return Column(
                    children: [
                      _buildAgentCard(index, isActive, isPast, state),
                      if (index < _agentConfig.length - 1)
                        _buildConnectionArrow(isActive, isPast),
                    ],
                  );
                },
              ),
            ),
            if (state.isCompleted)
              Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: _buildProceedButton(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentCard(int index, bool isActive, bool isPast, WorkflowState state) {
    final config = _agentConfig[index];
    final color = config['color'] as Color;

    return AnimatedBuilder(
      animation: _nodeControllers[index],
      builder: (context, child) {
        final scale = isActive ? 1.05 + (_nodeControllers[index].value * 0.05) : 1.0;
        final glowOpacity = isActive ? 0.3 + (_nodeControllers[index].value * 0.3) : (isPast ? 0.1 : 0.0);

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () => _showAgentLogs(context, index, config['name'], state.agentLogs[index] ?? []),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkSlateGrey,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isActive ? color : (isPast ? color.withValues(alpha: 0.5) : Colors.white10),
                  width: isActive ? 2 : 1,
                ),
                boxShadow: [
                  if (isActive || isPast)
                    BoxShadow(
                      color: color.withValues(alpha: glowOpacity),
                      blurRadius: isActive ? 30 : 10,
                      spreadRadius: isActive ? 5 : 0,
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isActive ? color.withValues(alpha: 0.2) : Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      config['icon'] as IconData,
                      color: isActive || isPast ? color : AppTheme.dimmedAlloyGrey,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                config['name'] as String,
                                style: TextStyle(
                                  color: isActive || isPast ? AppTheme.pearlWhite : AppTheme.dimmedAlloyGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPast)
                              Icon(Icons.check_circle, color: color, size: 20),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (isActive)
                          Text(
                            state.activeTaskDescription,
                            style: TextStyle(
                              color: color,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        else if (isPast)
                          const Text(
                            'Task Completed',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          )
                        else
                          const Text(
                            'Waiting for uplink...',
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionArrow(bool isCurrentActive, bool isPast) {
    final color = isPast || isCurrentActive ? AppTheme.electricIndigo : Colors.white10;
    return Container(
      height: 40,
      width: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            isPast ? color : Colors.white10,
          ],
        ),
      ),
      child: isCurrentActive
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Icon(Icons.arrow_downward, color: color, size: 16),
            )
          : null,
    );
  }

  Widget _buildProceedButton() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.electricIndigo,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          shadowColor: AppTheme.electricIndigo.withValues(alpha: 0.5),
        ),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('View Action Hub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onPressed: () => context.go('/action'),
      ),
    );
  }

  void _showAgentLogs(BuildContext context, int index, String agentName, List<String> logs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LogTerminalBottomSheet(agentName: agentName, logs: logs),
    );
  }
}

class _LogTerminalBottomSheet extends StatelessWidget {
  final String agentName;
  final List<String> logs;

  const _LogTerminalBottomSheet({required this.agentName, required this.logs});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.onyxBlack.withValues(alpha: 0.8),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.terminal, color: AppTheme.electricIndigo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '\$tail -f $agentName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 32),
              Expanded(
                child: logs.isEmpty
                    ? const Center(child: Text('No telemetry available.', style: TextStyle(color: Colors.white54)))
                    : ListView.separated(
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('> ', style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace')),
                              Expanded(
                                child: Text(
                                  logs[idx],
                                  style: const TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 13),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
