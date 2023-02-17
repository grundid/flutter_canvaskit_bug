import 'package:canvaskit/models.dart';
import 'package:canvaskit/shiftplan_calendar.dart';

class ShiftplanData {
  final Shiftplan shiftplan;

  ShiftplanData.withShiftplanRef(this.shiftplan) {
    _initShiftWeeks();
    for (ShiftWeek shiftWeek in shiftWeeks) {
      for (ShiftDay shiftDay in shiftWeek.shiftDays) {
        if (shiftDay.partOfShiftplan) {
          ShiftController shiftDayShift = ShiftController();

          for (int x = 0; x < persons.length; x++) {
            GroupedVote groupedVote = GroupedVote(Vote(
              employeeRef: "employeeRef-$x",
              person: persons[x],
            ));
            groupedVote.group = "employeeRef-$x";
            shiftDayShift.bids.add(groupedVote);
          }

          shiftDay.shifts.add(shiftDayShift);
        }
      }
    }
  }

  ShiftplanCalendar? _shiftplanCalendar;

  _initShiftWeeks() {
    _shiftplanCalendar =
        ShiftplanCalendar(shiftplan.from, shiftplan.to, minWeeks: 6);
  }

  List<ShiftWeek> get shiftWeeks =>
      _shiftplanCalendar?.shiftWeeks ?? <ShiftWeek>[];

  List<ShiftDay> get partOfShiftplanDays =>
      _shiftplanCalendar?.partOfShiftplanDays ?? <ShiftDay>[];

  Iterable<GroupedVote> getAllVotes() {
    return VotesIterable(() {
      List<GroupedVote> result = [];
      for (ShiftDay shiftDay in partOfShiftplanDays) {
        for (ShiftController shiftController in shiftDay.shifts) {
          result.addAll(shiftController.bids);
        }
      }
      return result.iterator;
    });
  }
}

class GroupedVote {
  late String group;
  final Vote vote;
  bool groupHighlighted = false;
  bool employeeHighlighted = false;
  DocumentReference get employeeRef => vote.employeeRef;

  bool get hasVoteHighlight => groupHighlighted || employeeHighlighted;

  GroupedVote(this.vote);
}

class ShiftDay {
  final bool today;

  int dayNo;
  bool partOfShiftplan;
  List<ShiftController> shifts = [];

  ShiftDay(
      {required this.dayNo, required this.today, this.partOfShiftplan = true});
}

class ShiftWeek {
  bool currentWeek;
  List<ShiftDay> shiftDays = [];

  ShiftWeek(this.currentWeek);
}

class ShiftController {
  List<GroupedVote> bids = [];
}

List<Person> persons = [
  Person(firstName: "firstName1", lastName: "lastName1"),
  Person(firstName: "firstName2", lastName: "lastName2"),
  Person(firstName: "firstName3", lastName: "lastName3"),
  Person(firstName: "firstName4", lastName: "lastName4"),
  Person(firstName: "firstName5", lastName: "lastName5"),
  Person(firstName: "firstName6", lastName: "lastName6"),
];

class VotesIterable extends Iterable<GroupedVote> {
  final Function generate;

  VotesIterable(this.generate);

  @override
  Iterator<GroupedVote> get iterator => generate();
}
