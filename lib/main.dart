import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:taskmanagement/src/collection/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ROUTES
import 'package:taskmanagement/src/pages/dashboard/dashboard.dart';
import 'package:taskmanagement/src/pages/task/taskpage.dart';

void main() async {
  runApp(const MyApp());

  /*final dir = await getApplicationSupportDirectory(); // path_provider package
  final isar = await Isar.open(
    [UserSchema],
    directory: dir.path,
    inspector: true, // if you want to enable the inspector for debug builds
  );

  final emails = await isar.users
      .filter()
      .titleContains('awesome', caseSensitive: false)
      .sortByStatusDesc()
      .limit(10)
      .findAll();
  //print(emails);

  final newEmail = User()
    ..title = 'Amazing new database'
    ..status = Status.draft;

  await isar.writeTxn(() async {
    await isar.users.put(newEmail); // insert & update
  });

  final existingEmail = await isar.users.get(newEmail.id!); // get
  //print(existingEmail!.id!);
  //print(existingEmail.toJson());

  final xxx = isar.users;
  //print(await xxx.where().findAll());

  await isar.writeTxn(() async {
    await isar.users.delete(existingEmail!.id!); // delete
  });*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(
        child: DashboardPage(),
      ),
      /* initialRoute: '/',
      routes: {
        '/': (context) => DashboardPage(),
        '/taskpage': (context) => TaskPage(),
      }, */
    );
  }
}