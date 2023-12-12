import 'package:flutter/material.dart';
import '../../Layout/HomeLayout/home_page.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class ServiceOff extends StatefulWidget {
  const ServiceOff({Key key}) : super(key: key);

  @override
  State<ServiceOff> createState() => _ServiceOffState();
}

class _ServiceOffState extends State<ServiceOff> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fastfood,size: 100,color: AppColor),
              height(20),
              Text('! مرحبا بك في كناري ',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500
              ),),
              height(20),
             Padding(
               padding: const EdgeInsets.only(left: 20,right: 20),
               child: Container(
                 child:Text('عذرا حاليا فترة ذروة لدينا بمدينتك ولحرصنا لضمان جودة التوصيل آخرنا قبول الطلبات حاول مرة أخرى رجوع بعد دقائق  شكرا لصبرك و تفهمك',style: TextStyle(
                   height: 2.5,
                   color: Colors.blueGrey,
                   fontWeight: FontWeight.bold
                 ),textAlign: TextAlign.center,),
               ),
             ),
            ],
          ),
        )
    );
  }
}
