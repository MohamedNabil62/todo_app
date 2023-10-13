import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo_app/cubit/states.dart';

import '../../../modules/todo_app/archived_tasks/archived_task_screen.dart';
import '../../../modules/todo_app/done_tasks/done_task_screen.dart';
import '../../../modules/todo_app/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  List<Map> tasks=[];
  List<Map> done_tasks=[];
  List<Map> archived_tasks=[];
  static AppCubit get(context) => BlocProvider.of(context);
  int Current_index=0;
  List<Widget>screen=[
    NewTaskScreen(),
    NewDoneScreen(),
    NewArchivedScreen(),
  ];

  List<String>title=[
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
 void ChangeIndex(int index)
{
  Current_index=index;
  emit(AppChangeBottomNavBarState());
}
  Database? database;
  bool staut=false;
  IconData icon=Icons.edit;
  Future<String>getname() async
  {
    return "true";
  }
  void creatdatabase(){
    openDatabase(
        "todo.db",
        version: 1,
        onCreate:(database,version){
          print("database created");
          database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY,titel TEXT,data TEXT,time TEXT,status TEXT)'
          ).then((value){}).catchError((error){
            print("error created string ${error.toString()}");
          });
        },
        onOpen: (database){
          getdataformdatabase(database);
          print("database opend");
        }
    ).then((value) {
      database=value;
      emit(AppCreatDataBaseState());
    });
  }

  Future insertdatabase(
      {
        @required String? title,
        @required String? data,
        @required String? time,
      }
      ) async{
     await database?.transaction((txn)
    {
      txn.rawInsert(
        'INSERT INTO Test (titel, data, time, status) VALUES (?, ?, ?, ?)',
        ['$title', '$data', '$time', 'now'],
      ).then((value)
      {
        print("$value insert is Done");
        emit(AppInsertDataBaseState());
        getdataformdatabase(database);

      }
      ).catchError((onError){
        print("error is ${onError.toString()}");
      });
      return getname();
    });
  }
  void getdataformdatabase(database){
     database!.rawQuery("SELECT * FROM Test").then((value) {
       emit(AppGetDataBaseState());
       tasks=[];
       done_tasks=[];
       archived_tasks=[];
       print(value);
      value.forEach((element) {
        if(element['status'] == 'now')
          {
            tasks.add(element);
          }
        if(element['status'] == 'done')
        {
          done_tasks.add(element);
        }
        if(element['status'] == 'archived')
        {
          archived_tasks.add(element);
        }
      });


     }) ;


  }
void ChangeBottemSheetState({
  @required bool? state,
  @required IconData? icons,
}){
    icon=icons!;
    staut=state!;
    emit(AppChangeBottomSheetState());
}
// Update some record
  void UpdateDateBase(
  {
  @required String? states,
  @required int? id
}
      ) async{
   database?.rawUpdate(
  'UPDATE Test SET status = ? WHERE id = ?',
  ['$states', '$id']).then((value) {
    getdataformdatabase(database);
    emit(AppUpdateDataBaseState());
   });
}
  void DeletDateBase(
      {
        @required int? id
      }
      ) async{
    database?.rawDelete('DELETE FROM Test WHERE id = ?', [id]
    ).then((value) {
      getdataformdatabase(database);
      emit(AppDeletDataBaseState());
    });
  }
}