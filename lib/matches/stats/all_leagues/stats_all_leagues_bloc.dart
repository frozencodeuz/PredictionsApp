import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:predictions/data/matches_bloc.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/matches/predictions/high_percent_checker.dart';
import 'package:predictions/matches/predictions/over_2_checker.dart';
import 'package:predictions/matches/predictions/under_3_checker.dart';
import 'package:predictions/matches/predictions/win_lose_draw_checker.dart';
import 'package:predictions/matches/stats/prediction_stat.dart';

class StatsAllLeaguesBloc {
  final StreamController<Map<String, List<PredictionStat>>> stats =
      StreamController<Map<String, List<PredictionStat>>>();

  void dispose() {
    stats.close();
  }

  StatsAllLeaguesBloc({@required MatchesBloc matchesBloc}) {
    matchesBloc.matches.listen(_loadStats);
  }

  void _loadStats(Matches matches) async {
    final statsMap = await compute(_getStats, matches);
    //_printDebugStuff(statsMap);
    stats.add(statsMap);
  }

  static Map<String, List<PredictionStat>> _getStats(Matches matches) {
    final groupedMatches = groupBy(matches.thisSeasonsMatches, (m) => m.league);
    return groupedMatches
        .map((key, value) => MapEntry(key, _getLeagueStats(value)));
  }

  static List<PredictionStat> _getLeagueStats(List<FootballMatch> matches) {
    final winLoseDrawStats = _getWinLoseDrawStats(matches);
    final highPercentStats = _getHighPercentStats(matches);
    final under3Stats = _getUnder3Stats(matches);
    final over2Stats = _getOver2Stats(matches);
    return [
      winLoseDrawStats,
      highPercentStats,
      under3Stats,
      over2Stats,
    ]..sort((left, right) => right.percentage.compareTo(left.percentage));
  }

  static PredictionStat _getWinLoseDrawStats(List<FootballMatch> matches) {
    final predictedMatches =
        matches.where((m) => m.hasFinalScore() && m.isBeforeToday());
    final predictedCorrectly = matches.where((m) {
      final checker = WinLoseDrawChecker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    return PredictionStat(
      type: "1X2",
      percentage: percentage,
      total: predictedMatches.length,
      totalCorrect: predictedCorrectly.length,
    );
  }

  static PredictionStat _getHighPercentStats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = HighPercentChecker(match: m);
      return checker.getPrediction() != HighPercentResult.Unknown;
    });
    final predictedCorrectly = matches.where((m) {
      final checker = HighPercentChecker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    return PredictionStat(
      type: "High",
      percentage: percentage,
      total: predictedMatches.length,
      totalCorrect: predictedCorrectly.length,
    );
  }

  static PredictionStat _getUnder3Stats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = Under3Checker(match: m);
      return checker.getPrediction();
    });
    final predictedCorrectly = predictedMatches.where((m) {
      final checker = Under3Checker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    return PredictionStat(
      type: "Under 2.5",
      percentage: percentage,
      total: predictedMatches.length,
      totalCorrect: predictedCorrectly.length,
    );
  }

  static PredictionStat _getOver2Stats(List<FootballMatch> matches) {
    final predictedMatches = matches.where((m) {
      if (!m.hasFinalScore() || !m.isBeforeToday()) {
        return false;
      }

      final checker = Over2Checker(match: m);
      return checker.getPrediction();
    });
    final predictedCorrectly = predictedMatches.where((m) {
      final checker = Over2Checker(match: m);
      return checker.isPredictionCorrect();
    });

    final percentage = predictedCorrectly.length == 0
        ? 0.0
        : predictedCorrectly.length / predictedMatches.length * 100;
    return PredictionStat(
      type: "Over 2.5",
      percentage: percentage,
      total: predictedMatches.length,
      totalCorrect: predictedCorrectly.length,
    );
  }

  void _printDebugStuff(Map<String, List<PredictionStat>> statsMap) {
    final results = [];
    final unders = [];
    final overs = [];
    statsMap.forEach((key, value) {
      value.forEach((s) {
        if (s.type == "1X2" && s.percentage > 55) {
          results.add(key);
        }

        if (s.type == "Under 2.5" && s.percentage > 70) {
          unders.add(key);
        }

        if (s.type == "Over 2.5" && s.percentage > 70) {
          overs.add(key);
        }
      });
    });

    print("Results");
    results.forEach((r) => print("    $r"));
    print("Unders");
    unders.forEach((u) => print("    $u"));
    print("Overs");
    overs.forEach((o) => print("    $o"));
  }
}
