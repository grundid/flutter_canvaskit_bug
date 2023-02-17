import 'package:canvaskit/models.dart';
import 'package:canvaskit/shiftplan_data.dart';
import 'package:canvaskit/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ObjectColor unmannedColor = ObjectColor(
    frontColor: Colors.black.value, backColor: Colors.redAccent.value);

final votingStatusUpcoming = Colors.red.shade700;
final votingStatusPast = Colors.amber.shade700;
final votingStatusActive = Colors.green.shade700;

const TextOverflow _defaultTextOverflow = TextOverflow.clip;

class _FromToHours {
  final String from;
  final bool fromOvertime;
  final String to;
  final bool toOvertime;

  _FromToHours(this.from, this.fromOvertime, this.to, this.toOvertime);
}

class BadgeConfig extends InheritedWidget {
  final Color frontColor;
  final Color backColor;

  BadgeConfig(
      {required this.frontColor,
      required this.backColor,
      required Widget child})
      : super(child: child);

  static BadgeConfig of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BadgeConfig>()!;

  bool updateShouldNotify(covariant BadgeConfig oldWidget) {
    return oldWidget.frontColor != frontColor;
  }
}

class ShiftBadge extends StatelessWidget {
  final ShiftController shift;
  final ShiftDay shiftDay;
  final Function(GroupedVote groupedVote) onVoteTap;

  ShiftBadge({
    Key? key,
    required this.shift,
    required this.shiftDay,
    required this.onVoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ObjectColor shiftColor = ObjectColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        child: BadgeConfig(
          frontColor: Color(shiftColor.frontColor),
          backColor: Color(shiftColor.backColor),
          child: Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(minHeight: 30),
                        color: BadgeConfig.of(context).backColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EmployeeShiftVotes(
                                shift: shift, onVoteTap: onVoteTap)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PersonLabel extends StatelessWidget {
  final Person person;
  final Color color;
  final Widget? leading;
  final Widget? trailing;

  const PersonLabel(
      {Key? key,
      required this.person,
      required this.color,
      this.trailing,
      this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nameLabel = person.fullLabel;
    double fontSize = 14;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Text(
              nameLabel,
              overflow: _defaultTextOverflow,
              softWrap: false,
              style: TextStyle(fontSize: fontSize, color: color),
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}

class EmployeeVoteLabel extends StatelessWidget {
  final GroupedVote groupedVote;
  final Function(GroupedVote groupedVote) onVoteTap;

  const EmployeeVoteLabel({
    Key? key,
    required this.groupedVote,
    required this.onVoteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (entered) {
        onVoteTap(groupedVote);
      },
      onTap: () {},
      child: Container(
        color: groupedVote.hasVoteHighlight
            ? BadgeConfig.of(context).frontColor
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: PersonLabel(
            person: groupedVote.vote.person,
            color: groupedVote.hasVoteHighlight
                ? Colors.white
                : BadgeConfig.of(context).frontColor,
            trailing: Padding(
              padding: const EdgeInsets.only(right: 2.0),
              child: Icon(
                groupedVote.groupHighlighted
                    ? Icons.person_add
                    : Icons.pan_tool,
                size: 12,
                color: groupedVote.hasVoteHighlight
                    ? Colors.white
                    : BadgeConfig.of(context).frontColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeShiftVotes extends StatelessWidget {
  final ShiftController shift;
  final Function(GroupedVote groupedVote) onVoteTap;

  const EmployeeShiftVotes(
      {Key? key, required this.shift, required this.onVoteTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (shift.bids.isNotEmpty) {
      return Column(
        children: [
          for (GroupedVote vote in shift.bids)
            EmployeeVoteLabel(
              groupedVote: vote,
              onVoteTap: onVoteTap,
            )
        ],
      );
    } else {
      return Container();
    }
  }
}
