import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localDbProvider = Provider<LocalDbService>((ref) {
  return LocalDbService();
});

class LocalDbService {
  static const String _boxName = 'tezads_campaigns';

  Future<void> openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  Future<void> saveSimulatedCampaign(Map<String, dynamic> campaignData) async {
    await openBox();
    final box = Hive.box(_boxName);
    await box.add(campaignData);
  }

  Future<List<Map<String, dynamic>>> getCampaigns() async {
    await openBox();
    final box = Hive.box(_boxName);
    return box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
