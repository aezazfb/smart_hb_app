const String hBDataTableName = 'hBDataTable';

class HBDataTableFields {
  static const List<String> myvalues = [
    id, fName, lName, hBValue, time
  ];
  static const String id = '_id';
  static const String fName = 'fName';
  static const String lName = 'lName';
  static const String hBValue = 'hBValue';
  static const String time = 'time';
}

class HBData{
  final int? id;
  final String firstName;
  final String lastName;
  final String hBValue;
  final DateTime date;

  const HBData({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.hBValue,
    required this.date,
  });

  HBData copy({
    int? id,
    String? firstName,
    String? lastName,
    String? hBValue,
    DateTime? date
  }) => HBData(id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      hBValue: hBValue ?? this.hBValue,
      date: date ?? this.date);

  static HBData fromJson(Map<String, Object?> js) => HBData(
      id: js[HBDataTableFields.id] as int?,
      firstName: js[HBDataTableFields.fName] as String,
      lastName: js[HBDataTableFields.lName] as String,
      hBValue: js[HBDataTableFields.hBValue] as String,
      date: DateTime.parse(js[HBDataTableFields.time] as String)
  );

  Map<String, Object?> toMyJson() => {
    HBDataTableFields.id : id,
    HBDataTableFields.fName : firstName,
    HBDataTableFields.lName : lastName,
    HBDataTableFields.hBValue : hBValue,  //for bool, HBDataTableFields.male : true ? 1 : 0
    HBDataTableFields.time : date.toIso8601String(),
  };

}

