
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

var textcon=TextEditingController();
var timecon=TextEditingController();
var datacon=TextEditingController();
var scf_key=GlobalKey<ScaffoldState>();
var formkey=GlobalKey<FormState>();
class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => AppCubit()..creatdatabase(),
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context, state) {
            if(state is AppInsertDataBaseState)
            {
              Navigator.pop(context);
            }
          },
          builder: (context, state) => Scaffold(
            key: scf_key,
            appBar: AppBar(
              title:Text(AppCubit.get(context).title[AppCubit.get(context).Current_index],),
              elevation: 0,
            ),
            body: AppCubit.get(context).screen[AppCubit.get(context).Current_index],
            floatingActionButton:FloatingActionButton(
              onPressed:(){
                if(AppCubit.get(context).staut)
                {
                  if(formkey.currentState!.validate())
                  {
                    AppCubit.get(context).insertdatabase(
                        title: textcon.text,
                        data: datacon.text,
                        time: timecon.text
                    );
                   /* insertdatabase(
                        data: datacon.text,
                        time: timecon.text,
                        title: textcon.text
                    ).then((value) {
                      /* Navigator.pop(context);
                    staut=false;
                    setState(() {
                      icon=Icons.edit;
                    });*/
                    });*/
                  }
                }
                else {
                  scf_key.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller:textcon,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return "title must not be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task title',
                                  prefix:Icon(Icons.title),
                                ),
                              ),
                              SizedBox(height: 5,),
                              TextFormField(
                                onTap: (){
                                  showTimePicker(context: context,
                                      initialTime: TimeOfDay.now()
                                  ).then((value) {
                                    timecon.text=value!.format(context).toString();
                                    print(value.format(context));
                                  });
                                },
                                keyboardType: TextInputType.phone,
                                controller:timecon,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return "time must not be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task time',
                                  prefix:Icon(Icons.watch_later_outlined),
                                ),
                              ),
                              SizedBox(height: 5,),
                              TextFormField(
                                onTap: (){
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:DateTime.parse("2024-09-01") ,

                                  ).then((value) {
                                    print( DateFormat.yMMMd().format(value!));
                                    datacon.text=DateFormat.yMMMd().format(value);
                                  });
                                },
                                keyboardType: TextInputType.datetime,
                                controller:datacon,
                                validator: (value){
                                  if(value!.isEmpty)
                                  {
                                    return "data must not be empty";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task data',
                                  prefix:Icon(Icons.calendar_today),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ).closed.then((value) {
                    AppCubit.get(context).ChangeBottemSheetState(
                        state: false,
                        icons: Icons.edit
                    );
                  }
                  );
                  AppCubit.get(context).ChangeBottemSheetState(
                      state: true,
                      icons: Icons.add
                  );

                }
              },
              child:Icon(AppCubit.get(context).icon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex:AppCubit.get(context).Current_index,
              onTap: (index){
                AppCubit.get(context).ChangeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon:Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(icon:Icon(Icons.check_circle_outline_outlined),
                    label: "Done"
                ),
                BottomNavigationBarItem(icon:Icon(Icons.archive_outlined),
                    label: "Archived"
                )
              ],
            ),
          ),
        ),
      );
  }
}
