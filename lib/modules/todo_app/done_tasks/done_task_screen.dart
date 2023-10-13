import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/todo_app/cubit/cubit.dart';
import '../../../layout/todo_app/cubit/states.dart';
import '../../../shared/components/components.dart';
class NewDoneScreen extends StatelessWidget {
  const NewDoneScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  AppCubit.get(context).done_tasks.length==0?
   Center(
      child: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 100,

          ),
          Text(
            'No Tasks Yet, Please Add Some Tasks',
            style:TextStyle(
                fontSize: 16,
                fontWeight:FontWeight.bold
            ),

          )

        ],
      ),
    ):
      BlocConsumer<AppCubit,AppStates>(
      builder: (context, state) =>   ListView.separated(
          itemBuilder:(context,index) =>buildtask(AppCubit.get(context).done_tasks[index],context),
          separatorBuilder:(context,index) => GestureDetector(
            onTap: (){},
            child: Container(
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          itemCount:AppCubit.get(context).done_tasks.length
      ),
      listener:(context, state) {},
    );
  }
}
