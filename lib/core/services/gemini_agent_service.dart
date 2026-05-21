import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the Gemini Agent Service
final geminiAgentProvider = Provider<GeminiAgentService>((ref) {
  return GeminiAgentService();
});

class GeminiAgentService {
  // IMPORTANT: For production, do NOT hardcode API keys. 
  // We use a placeholder for this hackathon context.
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
  late final GenerativeModel _model;

  GeminiAgentService() {
    _model = GenerativeModel(
      model: 'gemini-flash-latest',
      apiKey: 'YOUR_API_KEY_HERE',
    );
  }

  /// AGENT 1: The Fact Extraction & Context Consolidation Agent
  /// Isolates numeric trends from raw data and correlates them to the user complaint.
  Future<String> factExtraction({
    required List<Map<String, dynamic>> parsedData,
    required String userPrompt,
  }) async {
    final prompt = '''
    You are the Fact Extraction Agent.
    User's business complaint: "$userPrompt"
    Raw Data: ${jsonEncode(parsedData)}
    
    Task: Correlate the complaint with the raw data. Isolate the explicit numeric trends.
    Output your findings concisely.
    ''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? 'No facts extracted.';
  }

  /// AGENT 2: The Strategy & Execution Planner
  /// Autonomously calculates target parameters (geo-exclusions, budget weights, splits).
  Future<String> strategyPlanner(String extractedFacts) async {
    final prompt = '''
    You are the Strategy Planner Agent.
    Extracted Facts: "$extractedFacts"
    
    Task: Formulate structural tactical corrections. 
    Determine target parameters (e.g., localized geo-exclusions, budget redistribution away from high CPC vectors).
    Output the strategy clearly.
    ''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? 'No strategy planned.';
  }

  /// AGENT 3: The Execution & Tool Bridge Agent
  /// Transforms the plan into a structured JSON configuration simulating state changes.
  Future<Map<String, dynamic>> executionBridge(String strategyPlan) async {
    final prompt = '''
    You are the Execution Agent.
    Strategy Plan: "$strategyPlan"
    
    Task: Translate the abstract plan into a concrete, structured JSON configuration.
    The JSON must contain:
    - "target_metrics": { ... }
    - "budget_values": { ... }
    - "placement_targets": [ ... ]
    - "geo_exclusions": [ ... ]
    
    Output ONLY valid JSON.
    ''';

    final response = await _model.generateContent([Content.text(prompt)]);
    String text = response.text ?? '{}';
    
    // Clean markdown formatting if present
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();
    
    try {
      return jsonDecode(text);
    } catch (e) {
      return {'error': 'Failed to parse JSON', 'raw': text};
    }
  }
}
