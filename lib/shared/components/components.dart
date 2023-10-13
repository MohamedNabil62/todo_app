import 'package:flutter/material.dart';
import '../../layout/todo_app/cubit/cubit.dart';

Widget buildtask(Map model,context){
  return Dismissible(
    key:Key(model['id'].toString()),
    onDismissed:((direction) {
      AppCubit.get(context).DeletDateBase(id: model['id']);
    }),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(model['time']),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(model['titel'],
                  style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),
                Text(model['data'],
                  style:TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
          SizedBox(width: 20,),
          IconButton(
              onPressed:(){
                AppCubit.get(context).UpdateDateBase(states: "done", id:model['id']);
              } ,
              icon:Icon(
                Icons.check_circle_rounded,
                //size: 30,
                color: Colors.green,
              )

          ),
          IconButton(
              onPressed:(){
                AppCubit.get(context).UpdateDateBase(states: "archived", id:model['id']);
              } ,
              icon:Icon(
                Icons.archive,
                //size: 30,
                color: Colors.black54,
              )

          )
        ],
      ),
    ),
  );
}