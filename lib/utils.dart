DateTime weekStart(DateTime date) {
  DateTime firstDateOfWeek =
      date.add(Duration(days: -((date.weekday - DateTime.monday) % 7)));
  return DateTime(
      firstDateOfWeek.year, firstDateOfWeek.month, firstDateOfWeek.day);
}

extension FindFirst<E> on Iterable<E> {
  E? findFirst(bool test(E element)) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

bool isNotEmpty(String? s) => s != null && s.isNotEmpty;

enum Width { small, medium, large }

Width decideWidth(double width) {
  if (width > 110) {
    return Width.large;
  } else if (width <= 110 && width > 60) {
    return Width.medium;
  } else {
    return Width.small;
  }
}
