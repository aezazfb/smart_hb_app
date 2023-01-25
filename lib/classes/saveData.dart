import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:smart_hb_app/Models/hBProfileData.dart';
import 'package:sqflite/sqflite.dart';


// final database = openDatabase(
//   // Set the path to the database. Note: Using the `join` function from the
//   // `path` package is best practice to ensure the path is correctly
//   // constructed for each platform.
//     join(await getDatabasesPath(), 'doggie_database.db'),
// // When the database is first created, create a table to store dogs.
//     onCreate: (db, version) {
// // Run the CREATE TABLE statement on the database.
// return db.execute(
// 'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
// );
// },
// // Set the version. This executes the onCreate function and provides a
// // path to perform database upgrades and downgrades.
// version: 1,
// );

class db_connection{

  static final db_connection instance= db_connection._init();
  static Database? _db;

  db_connection._init();

  Future<Database> get db_opening async {
    if(_db!=null) return _db!;

    _db = await _initDB('hBDatabase.db');
    return _db!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {

    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT'; // = 'INTEGER NOT NULL'; for nullable integers
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    print("db created Az");


    //Creating dataTable with column Names and their Datatype/
    await db.execute('''
    CREATE TABLE $hBDataTableName (
    ${HBDataTableFields.id} $idType,
    ${HBDataTableFields.fName} $textType,
    ${HBDataTableFields.age} $intType,
    ${HBDataTableFields.gender} $textType,
    ${HBDataTableFields.hBValue} $textType,
    ${HBDataTableFields.time} $textType    
    )
    ''');

    await db.execute('''
    CREATE TABLE $hBDataTableNameWithId (
    ${HBDataTableFields.id} 'INTEGER',
    ${HBDataTableFields.fName} $textType,
    ${HBDataTableFields.age} 'INTEGER',
    ${HBDataTableFields.gender} 'TEXT',
    ${HBDataTableFields.hBValue} $textType,
    ${HBDataTableFields.time} $textType   
    )
    ''');
    print("Table Create Az!");
  }

  Future closeDb() async{
    final db = await instance.db_opening;
    _db = null;
    db.close();
    print('db closed Az');
  }

  Future<HBData> create (HBData hbDataValues) async {
    final db = await instance.db_opening;

    // final sonj = hbDataValues.toMyJson();
    // const columns = '${HBDataTableFields.hBValue}, ${HBDataTableFields.fName}';
    // final values = '${sonj[HBDataTableFields.hBValue]}, ${sonj[HBDataTableFields.fName]}';

    //final idNew = await db.rawInsert("INSERT into table_name ($columns) VALUES ($values)"); //Simple SQL ki query !

    //print("Adding new Value Az");
    final idNew = await db.insert(hBDataTableName, hbDataValues.toMyJson());
    //print("Added    new Value Az");

    return hbDataValues.copy(id : idNew);
  }

  Future<HBData> createHb (HBData hbDataWithId) async {
    final db = await instance.db_opening;

    // final sonj = hbDataValues.toMyJson();
    // const columns = '${HBDataTableFields.hBValue}, ${HBDataTableFields.fName}';
    // final values = '${sonj[HBDataTableFields.hBValue]}, ${sonj[HBDataTableFields.fName]}';

    //final idNew = await db.rawInsert("INSERT into table_name ($columns) VALUES ($values)"); //Simple SQL ki query !

    print("Adding new Value Az");
    final profileId = await db.insert(hBDataTableNameWithId, hbDataWithId.toMyJson());
    print("Added    new Value Az");

    return hbDataWithId.copy(id : profileId);
  }

  Future<HBData> getHB(String f_Name) async {
    final db = await instance.db_opening;

    // final maps = await db.query(
    //   hBDataTableName,
    //   columns: HBDataTableFields.myvalues,
    //   where: '${HBDataTableFields.fName} = ?',
    //   whereArgs: [f_Name]
    // );

    final maps = await db.rawQuery("SELECT * FROM $hBDataTableName WHERE fName = '$f_Name'");

    if(maps.isNotEmpty){
      return HBData.fromJson(maps.first);
    }
    else{
      throw Exception('$f_Name not found!');
    }
  }

  Future<HBData> getHBbyId(int? profileId) async {
    final db = await instance.db_opening;

    // final maps = await db.query(
    //   hBDataTableName,
    //   columns: HBDataTableFields.myvalues,
    //   where: '${HBDataTableFields.fName} = ?',
    //   whereArgs: [f_Name]
    // );

    print("Az getting Value");

    int pro = 1;

    // if(profileId != null)
    //   pro = pro + int.parse(profileId);

    final maps = await db.rawQuery("SELECT * FROM $hBDataTableNameWithId WHERE ${HBDataTableFields.id} = $profileId");

    if(maps.isNotEmpty){
      return HBData.fromJson(maps.first);
    }
    else{
      throw Exception('$profileId not found!');
    }
  }

  Future<List<HBData>> getAllhBProfiles() async{
    final db = await instance.db_opening;

    const orderByVal = '${HBDataTableFields.time} ASC';
    final myResult = await db.rawQuery("SELECT * FROM $hBDataTableName ORDER BY $orderByVal");
    // final myResult = await db.rawQuery("SELECT DISTINCT * FROM $hBDataTableName ORDER BY $orderByVal");
    //final myResult = await db.query(hBDataTableNameWithId, orderBy: orderByVal);

    return myResult.map((eData) => HBData.fromJson(eData)).toList();
  }

  Future<List<HBData>> getAllhBsById(int? profId) async{
    final db = await instance.db_opening;

    const orderByVal = '${HBDataTableFields.time} ASC';
    final myResult = await db.rawQuery("SELECT * FROM $hBDataTableNameWithId WHERE _id = ${profId} ORDER BY $orderByVal");
    // final myResult = await db.rawQuery("SELECT DISTINCT * FROM $hBDataTableName ORDER BY $orderByVal");
    //final myResult = await db.query(hBDataTableNameWithId, orderBy: orderByVal);

    return myResult.map((eData) => HBData.fromJson(eData)).toList();
  }

  Future<int> updateHb(HBData theData) async {
    final db = await instance.db_opening;

    return db.update(hBDataTableName, theData.toMyJson(),
    where: '${HBDataTableFields.id} = ?',
    whereArgs: [theData.id]);
  }

  Future<int> deleteHbData (int theId) async {
    final db = await instance.db_opening;

    return db.delete(hBDataTableName,
    where: '${HBDataTableFields.id} = ?',
    whereArgs: [theId]);
  }

}