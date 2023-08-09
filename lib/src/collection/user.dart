import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  String? title;
  String? clientcode;
  String? clienturl;

  List<Recipient>? recipients;

  @enumerated
  Status status = Status.pending;

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'status': status};


}

@embedded
class Recipient {
  String? name;

  String? address;
}

enum Status {
  draft,
  pending,
  sent,
}
/*
class UserData {
  final Isar isar;
  Future<void> setClientUrl(String clientcode,String clienturl) async {
//  this.storage.set('clientcode', clientcode);
//  this.storage.set('clienturl', clienturl);

    await setValue(clientcode, clienturl);
  }



  Future<void> setValue(String key,dynamic value) async {
//  this.storage.set('clientcode', clientcode);
//  this.storage.set('clienturl', clienturl);


   // final newEmail = User()..&&key = 'Amazing new database' ..status=Status.draft;



    final xxx = isar.users;
    List<User> arrusers = await xxx.where().findAll();
    if( arrusers.length >0 ){

      (arrusers[0].)
    }else{
      print('missing data');
    }

  }
}*/
