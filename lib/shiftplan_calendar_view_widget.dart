import 'package:canvaskit/shift_badge.dart';
import 'package:canvaskit/shiftplan_calendar_utils_cubit.dart';
import 'package:canvaskit/shiftplan_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShiftplanCalendarViewWidget extends StatelessWidget {
  final ShiftplanData shiftplanData;

  const ShiftplanCalendarViewWidget({
    Key? key,
    required this.shiftplanData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShiftplanCalendarUtilsCubit>(
          create: (context) => ShiftplanCalendarUtilsCubit(),
        )
      ],
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<ShiftplanCalendarUtilsCubit,
                    ShiftplanCalendarUtilsState>(
                  builder: (context, utilsState) {
                    return _CalendarView(
                      shiftplanData: shiftplanData,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  final ShiftplanData shiftplanData;

  const _CalendarView({
    Key? key,
    required this.shiftplanData,
  }) : super(key: key);

  TableRow _week(BuildContext context, ShiftWeek shiftWeek) {
    return TableRow(
      children: [
        for (ShiftDay shiftDay in shiftWeek.shiftDays)
          InkWell(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: shiftDay.partOfShiftplan ? null : Colors.black12,
                ),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 2.0, bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      CalendarDay(shiftDay: shiftDay),
                      for (ShiftController shift in shiftDay.shifts)
                        ShiftBadge(
                          shift: shift,
                          shiftDay: shiftDay,
                          onVoteTap: (groupedVote) {
                            context
                                .read<ShiftplanCalendarUtilsCubit>()
                                .toggleVoteHighlight(
                                    shiftplanData.getAllVotes(),
                                    !groupedVote.hasVoteHighlight,
                                    groupedVote);
                          },
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<TableRow> _month(BuildContext context) {
    return shiftplanData.shiftWeeks
        .map((shiftWeek) => _week(context, shiftWeek))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      children: _month(context),
    );
  }
}

class CalendarDay extends StatelessWidget {
  final ShiftDay shiftDay;
  const CalendarDay({super.key, required this.shiftDay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: shiftDay.today ? Colors.blue : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${shiftDay.dayNo}',
                style: TextStyle(
                    color: shiftDay.today ? Colors.white : null,
                    fontSize: 12.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
