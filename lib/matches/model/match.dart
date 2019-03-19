class Match {
  final String date;
  final int leagueId;
  final String league;
  final String homeTeam;
  final String awayTeam;
  final double homeSpiRating;
  final double awaySpiRating;
  final double homeWinProbability;
  final double awayWinProbability;
  final double drawProbability;
  final double homeProjectedGoals;
  final double awayProjectedGoals;
  final double homeImportance;
  final double awayImportance;
  final int homeFinalScore;
  final int awayFinalScore;
  final double homeExpectedGoals;
  final double awayExpectedGoals;
  final double homeNonShotExpectedGoals;
  final double awayNonShotExpectedGoals;
  final double homeAdjustedScore;
  final double awayAdjustedScore;

  factory Match.fromCsv(List match) {
    return Match._(
      match[0],
      match[1],
      match[2],
      match[3],
      match[4],
      match[5],
      match[6],
      match[7],
      match[8],
      match[9],
      match[10],
      match[11],
      match[12] == "" ? null : match[12],
      match[13] == "" ? null : match[13],
      match[14] == "" ? null : match[14],
      match[15] == "" ? null : match[15],
      match[16] == "" ? null : match[16],
      match[17] == "" ? null : match[17],
      match[18] == "" ? null : match[18],
      match[19] == "" ? null : match[19],
      match[20] == "" ? null : match[20],
      match[21] == "" ? null : match[21],
    );
  }

  Match._(
      this.date,
      this.leagueId,
      this.league,
      this.homeTeam,
      this.awayTeam,
      this.homeSpiRating,
      this.awaySpiRating,
      this.homeWinProbability,
      this.awayWinProbability,
      this.drawProbability,
      this.homeProjectedGoals,
      this.awayProjectedGoals,
      this.homeImportance,
      this.awayImportance,
      this.homeFinalScore,
      this.awayFinalScore,
      this.homeExpectedGoals,
      this.awayExpectedGoals,
      this.homeNonShotExpectedGoals,
      this.awayNonShotExpectedGoals,
      this.homeAdjustedScore,
      this.awayAdjustedScore);

  bool hasBeenPlayed() {
    return homeFinalScore != null && awayFinalScore != null;
  }
}
