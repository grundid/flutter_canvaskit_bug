import 'package:canvaskit/shiftplan_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'shiftplan_calendar_utils_state.dart';

class ShiftplanCalendarUtilsCubit extends Cubit<ShiftplanCalendarUtilsState> {
  ShiftplanCalendarUtilsCubit() : super(ShiftplanCalendarUtilsInitialized());

  void toggleVoteHighlight(Iterable<GroupedVote> groupedVotes,
      bool highlightVote, GroupedVote groupedVote) {
    if (highlightVote) {
      _selectVote(groupedVotes, groupedVote);
    } else {
      _deselectVote(groupedVotes);
    }
    emit(ShiftplanCalendarUtilsInitialized());
  }

  _selectVote(Iterable<GroupedVote> groupedVotes, GroupedVote vote) {
    for (GroupedVote groupedVote in groupedVotes) {
      groupedVote.groupHighlighted = groupedVote.group == vote.group;
      groupedVote.employeeHighlighted =
          groupedVote.employeeRef == vote.employeeRef;
    }
  }

  _deselectVote(Iterable<GroupedVote> groupedVotes) {
    for (GroupedVote groupedVote in groupedVotes) {
      groupedVote.groupHighlighted = false;
      groupedVote.employeeHighlighted = false;
    }
  }
}
