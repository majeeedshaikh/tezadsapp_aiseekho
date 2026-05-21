import 'package:flutter/foundation.dart';

class CsvParserService {
  /// Parses raw CSV string data into a list of maps on a background isolate
  /// to prevent freezing the main UI thread during large dataset ingestion.
  static Future<List<Map<String, dynamic>>> parseCsvInBackground(String csvString) async {
    return compute(_parseCsvData, csvString);
  }

  /// The isolated function that does the heavy lifting
  static List<Map<String, dynamic>> _parseCsvData(String csvString) {
    final lines = csvString.split('\n');
    if (lines.isEmpty) return [];

    final headers = lines.first.split(',').map((e) => e.trim()).toList();
    final List<Map<String, dynamic>> parsedData = [];

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final values = line.split(',').map((e) => e.trim()).toList();
      final Map<String, dynamic> row = {};

      for (int j = 0; j < headers.length; j++) {
        if (j < values.length) {
          row[headers[j]] = values[j];
        } else {
          row[headers[j]] = '';
        }
      }
      parsedData.add(row);
    }
    return parsedData;
  }
}
