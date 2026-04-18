enum LiturgicalSeason {
  advent,
  christmas,
  ordinaryTime,
  lent,
  easter,
  pentecost,
}

class LiturgicalCalendar {
  static LiturgicalSeason getCurrentSeason() {
    final now = DateTime.now();
    final year = now.year;

    final easter = _getEasterDate(year);
    final ashWednesday = easter.subtract(const Duration(days: 46));
    final pentecost = easter.add(const Duration(days: 49));

    // Advent — 4 Sundays before Christmas
    final christmas = DateTime(year, 12, 25);
    final advent = _getAdventStart(year);

    if (_isBetween(now, advent, christmas)) {
      return LiturgicalSeason.advent;
    } else if (_isBetween(now, christmas, DateTime(year + 1, 1, 13))) {
      return LiturgicalSeason.christmas;
    } else if (_isBetween(now, ashWednesday, easter)) {
      return LiturgicalSeason.lent;
    } else if (now.isAtSameMomentAs(easter) ||
        _isBetween(now, easter, pentecost)) {
      return LiturgicalSeason.easter;
    } else if (now.month == pentecost.month && now.day == pentecost.day) {
      return LiturgicalSeason.pentecost;
    } else {
      return LiturgicalSeason.ordinaryTime;
    }
  }

  static bool _isBetween(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start) && date.isBefore(end);
  }

  static DateTime _getEasterDate(int year) {
    final a = year % 19;
    final b = year ~/ 100;
    final c = year % 100;
    final d = b ~/ 4;
    final e = b % 4;
    final f = (b + 8) ~/ 25;
    final g = (b - f + 1) ~/ 3;
    final h = (19 * a + b - d - g + 15) % 30;
    final i = c ~/ 4;
    final k = c % 4;
    final l = (32 + 2 * e + 2 * i - h - k) % 7;
    final m = (a + 11 * h + 22 * l) ~/ 451;
    final month = (h + l - 7 * m + 114) ~/ 31;
    final day = ((h + l - 7 * m + 114) % 31) + 1;
    return DateTime(year, month, day);
  }

  static DateTime _getAdventStart(int year) {
    final christmas = DateTime(year, 12, 25);
    final daysToSunday = christmas.weekday % 7;
    final fourthSunday = christmas.subtract(Duration(days: daysToSunday));
    return fourthSunday.subtract(const Duration(days: 21));
  }

  static String getSeasonName(LiturgicalSeason season) {
    switch (season) {
      case LiturgicalSeason.advent:
        return 'Advent';
      case LiturgicalSeason.christmas:
        return 'Christmas Season';
      case LiturgicalSeason.lent:
        return 'Lent';
      case LiturgicalSeason.easter:
        return 'Easter Season';
      case LiturgicalSeason.pentecost:
        return 'Pentecost';
      case LiturgicalSeason.ordinaryTime:
        return 'Ordinary Time';
    }
  }
}
