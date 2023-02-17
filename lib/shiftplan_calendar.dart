import 'package:canvaskit/shiftplan_data.dart';
import 'package:canvaskit/utils.dart';

class ShiftplanCalendar {
  final List<ShiftWeek> shiftWeeks;

  ShiftplanCalendar._(this.shiftWeeks);

  factory ShiftplanCalendar(DateTime from, DateTime to, {int minWeeks = 4}) {
    DateTime startTime = from;
    DateTime endTime = to;
    DateTime countingDay = weekStart(startTime);
    List<ShiftWeek> shiftWeeks = [];

    while (countingDay.isBefore(endTime) || shiftWeeks.length < minWeeks) {
      ShiftWeek shiftWeek = ShiftWeek(false);
      for (int x = 0; x < 7; x++) {
        ShiftDay shiftDay = ShiftDay(
            dayNo: countingDay.day,
            today: false,
            partOfShiftplan: !countingDay.isBefore(startTime) &&
                countingDay.isBefore(endTime));

        shiftWeek.shiftDays.add(shiftDay);
        countingDay = countingDay.add(Duration(days: 1));
      }
      shiftWeeks.add(shiftWeek);
    }
    return ShiftplanCalendar._(shiftWeeks);
  }

  /// returns all [ShiftDay]s that are part of this shiftplan
  List<ShiftDay> get partOfShiftplanDays {
    List<ShiftDay> result = [];
    for (ShiftWeek week in shiftWeeks) {
      for (ShiftDay day in week.shiftDays) {
        if (day.partOfShiftplan) {
          result.add(day);
        }
      }
    }
    return result;
  }
}
