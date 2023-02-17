typedef DynamicMap = Map<String, dynamic>;
typedef DocumentReference = String;

class ObjectColor {
  int backColor;
  int frontColor;

  ObjectColor({this.backColor = 0xFFFFFFFF, this.frontColor = 0xFF000000});
}

final String noBreak = String.fromCharCode(0x00A0);

class Person {
  String? title;
  String? gender;
  String firstName;
  String lastName;

  String? _shortLabel;
  Person(
      {required this.firstName,
      required this.lastName,
      this.gender,
      this.title});

  String get uiDisplayName {
    if (title != null && title!.isNotEmpty) {
      return "${title} ${firstName} ${lastName}";
    } else {
      return "${firstName} ${lastName}";
    }
  }

  String get shortLabel {
    _shortLabel ??= lastName;
    return _shortLabel!;
  }

  set shortLabel(String value) {
    _shortLabel = value;
  }

  String get mediumLabel {
    return firstName.isNotEmpty
        ? firstName.substring(0, 1) + ".$noBreak$lastName"
        : shortLabel;
  }

  String get fullLabel {
    return "${firstName}$noBreak${lastName}";
  }
}

class Vote {
  DocumentReference employeeRef;
  Person person;
  Vote({
    required this.employeeRef,
    required this.person,
  });

  factory Vote.fromShift(DocumentReference employeeRef, Person person) {
    return Vote(
      employeeRef: employeeRef,
      person: person,
    );
  }
}

class Shiftplan {
  DocumentReference? selfRef;
  DateTime from;
  DateTime to;

  Shiftplan({
    required this.from,
    required this.to,
    this.selfRef,
  });
}
