import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:http/http.dart';
import 'package:predictions/matches/model/football_match.dart';

class MatchesApi {
  static const _url = "https://projects.fivethirtyeight.com/soccer-api/club/spi_matches.csv";

  Future<List<FootballMatch>> fetchMatches() async {
    final response = await get(_url);
    final csvString = utf8.decode(response.bodyBytes);

    final result = CsvToListConverter(eol: "\n").convert(csvString);
    result.removeAt(0); //Remove headings

    return _parseMatches(result);
  }

  Future<List<FootballMatch>> _parseMatches(List csvMatches) async {
    return csvMatches.map((match) => FootballMatch.fromCsv(match)).toList();
  }
}