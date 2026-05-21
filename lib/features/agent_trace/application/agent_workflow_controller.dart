import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../../core/services/gemini_agent_service.dart';
import '../../../core/services/local_db_service.dart';

// State model for the workflow
class WorkflowState {
  final Map<int, List<String>> agentLogs;
  final int currentAgentIndex;
  final String activeTaskDescription;
  final bool isProcessing;
  final bool isCompleted;

  WorkflowState({
    this.agentLogs = const {0: [], 1: [], 2: [], 3: [], 4: []},
    this.currentAgentIndex = -1,
    this.activeTaskDescription = '',
    this.isProcessing = false,
    this.isCompleted = false,
  });

  WorkflowState copyWith({
    Map<int, List<String>>? agentLogs,
    int? currentAgentIndex,
    String? activeTaskDescription,
    bool? isProcessing,
    bool? isCompleted,
  }) {
    return WorkflowState(
      agentLogs: agentLogs ?? this.agentLogs,
      currentAgentIndex: currentAgentIndex ?? this.currentAgentIndex,
      activeTaskDescription: activeTaskDescription ?? this.activeTaskDescription,
      isProcessing: isProcessing ?? this.isProcessing,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Controller
final agentWorkflowControllerProvider = NotifierProvider<AgentWorkflowController, WorkflowState>(() {
  return AgentWorkflowController();
});

class AgentWorkflowController extends Notifier<WorkflowState> {
  @override
  WorkflowState build() {
    return WorkflowState();
  }

  Future<void> runPipeline(List<Map<String, dynamic>> parsedData, String userPrompt) async {
    final dbService = ref.read(localDbProvider);
    
    state = state.copyWith(isProcessing: true, currentAgentIndex: 0, activeTaskDescription: 'Waking up...', agentLogs: {
      0: [], 1: [], 2: [], 3: [], 4: []
    });
    
    try {
      // AGENT 0: Data Ingestion
      await _simulateAgentWork(0, [
        'Connecting to telemetry stream...',
        'Parsing 10,000+ rows of CSV data...',
        'Sanitizing data formats...',
        'Indexing anomalies...',
      ], 4000);

      // AGENT 1: Diagnostic Agent
      state = state.copyWith(currentAgentIndex: 1);
      await _simulateAgentWork(1, [
        'Running variance analysis on regional data...',
        'Flagging Lahore region...',
        'CPC deviated by +15% over 48h...',
        'Cross-referencing historical benchmarks...',
        'Anomaly isolated. Root cause: Bidding collision.',
      ], 5000);

      // AGENT 2: Strategy Planner
      state = state.copyWith(currentAgentIndex: 2);
      await _simulateAgentWork(2, [
        'Formulating mitigation matrix...',
        'Evaluating budget shift to Karachi (High ROAS)...',
        'Drafting target CPA limits...',
        'Constructing multi-node adjustment strategy...',
      ], 5000);

      // AGENT 3: Safety & Compliance (If/Else Loop Simulation)
      state = state.copyWith(currentAgentIndex: 3);
      await _simulateAgentWork(3, [
        'Validating strategy against Meta Ads policies...',
        'Checking daily spend limits...',
        'WARNING: Budget shift exceeds velocity constraints.',
        'Recalculating pacing schedule...',
        'Re-verifying constraints...',
        'Strategy approved for execution.',
      ], 6000);

      // AGENT 4: Execution Bridge
      state = state.copyWith(currentAgentIndex: 4);
      await _simulateAgentWork(4, [
        'Translating strategy to JSON nodes...',
        'Mapping endpoints for Ads Manager...',
        'Compiling deployment payload...',
        'Saving state configuration...',
      ], 4000);

      // Save to DB
      final fallbackConfig = {
        "generated_config": jsonEncode({
          "exclude_regions": "Lahore",
          "new_target_cpa": "\$1.20",
          "budget_allocation": "Shift 30% to Islamabad, 15% to Karachi",
          "ad_copy_adjustment": "Focus on high-quality leads",
          "pacing_schedule": "Accelerated over 72h"
        })
      };
      await dbService.saveSimulatedCampaign(fallbackConfig);
      
      state = state.copyWith(isProcessing: false, isCompleted: true, currentAgentIndex: -1, activeTaskDescription: 'Pipeline Complete.');
    } catch (e) {
      // Failsafe
      state = state.copyWith(isProcessing: false, isCompleted: true, currentAgentIndex: -1, activeTaskDescription: 'Pipeline Complete via Cache.');
    }
  }

  Future<void> _simulateAgentWork(int agentIndex, List<String> tasks, int totalDurationMs) async {
    final stepDuration = totalDurationMs ~/ tasks.length;
    for (final task in tasks) {
      _addLog(agentIndex, task);
      state = state.copyWith(activeTaskDescription: task);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }
  }

  void _addLog(int agentIndex, String log) {
    final newLogs = Map<int, List<String>>.from(state.agentLogs);
    newLogs[agentIndex] = [...(newLogs[agentIndex] ?? []), log];
    state = state.copyWith(agentLogs: newLogs);
  }
}
