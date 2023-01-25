const String hBDataTableName = 'hBDataTable';
const String hBDataTableNameWithId = 'HbsWithId';

class HBDataTableFields {
  static const List<String> myvalues = [
    id, fName, age, hBValue, time
  ];
  static const String id = '_id';
  static const String fName = 'fName';
  static const String age = 'age';
  static const String gender = 'gender';
  static const String hBValue = 'hBValue';
  static const String time = 'time';
}

class HBData{
  final int? id;
  final String firstName;
  final int? age;
  final String? gender;
  final String hBValue;
  final DateTime date;

  const HBData({
    this.id,
    required this.firstName,
    this.age,
    this.gender,
    required this.hBValue,
    required this.date,
  });

  HBData copy({
    int? id,
    String? firstName,
    int? age,
    String? gender,
    String? hBValue,
    DateTime? date
  }) => HBData(id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      hBValue: hBValue ?? this.hBValue,
      date: date ?? this.date);

  static HBData fromJson(Map<String, Object?> js) => HBData(
      id: js[HBDataTableFields.id] as int?,
      firstName: js[HBDataTableFields.fName] as String,
      age: js[HBDataTableFields.age] as int,
      gender: js[HBDataTableFields.gender] as String,
      hBValue: js[HBDataTableFields.hBValue] as String,
      date: DateTime.parse(js[HBDataTableFields.time] as String)
  );

  Map<String, Object?> toMyJson() => {
    HBDataTableFields.id : id,
    HBDataTableFields.fName : firstName,
    HBDataTableFields.age : age,
    HBDataTableFields.gender : gender,
    HBDataTableFields.hBValue : hBValue,  //for bool, HBDataTableFields.male : true ? 1 : 0
    HBDataTableFields.time : date.toIso8601String(),
  };

}

