import 'package:meta/meta.dart';
import 'package:predictions/data/leagues.dart';
import 'package:predictions/data/model/football_match.dart';
import 'package:predictions/data/teams.dart';

class Under3Checker {
  final FootballMatch match;

  Under3Checker({@required this.match});

  bool getPrediction() {
    final leagueAverage = goalAverages[match.leagueId];
    final predictedTotal = match.homeProjectedGoals + match.awayProjectedGoals;
    return leagueAverage < 2.45 && predictedTotal < 2.45;
  }

  bool getPredictionIncludingPerformance() {
    final prediction = getPrediction();
    if (!prediction) {
      return false;
    }

    return underPerformingGoalsTeams.contains("(H) ${match.homeTeam}") ||
        underPerformingGoalsTeams.contains("(A) ${match.awayTeam}");
  }

  bool isPredictionCorrect() {
    if (!match.hasFinalScore() || !getPrediction()) {
      return false;
    }

    return match.homeFinalScore + match.awayFinalScore < 3;
  }
}
