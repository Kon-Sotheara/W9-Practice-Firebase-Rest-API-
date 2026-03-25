// ignore: non_constant_identifier_names
String DurationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(1, '0');

  final minutes = twoDigits(duration.inMinutes.remainder(60));

  return "$minutes mns";
}