import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../Layout/shopcubit/shopcubit.dart';
import '../../shared/components/components.dart';
import '../../shared/network/remote/cachehelper.dart';
import 'order.dart';


class Payment extends StatefulWidget {
  final int refCode;

  const Payment({Key key,this.refCode}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String title;
  String description;
  String device_id = Cachehelper.getData(key:"deviceId");
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  String access_token = Cachehelper.getData(key: "token");
  bool isDone = true;
  bool _isLoading = true;
  int currentIndex = 0;
  Map<String, dynamic> myorder = {};

   Future order()async{
      await http.get(
          Uri.parse('https://www.api.canariapp.com/v1/client/orders/${widget.refCode}?include=products,store,reviews'),
          headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}',}
      ).then((value) {
        var responsebody = jsonDecode(value.body);
        myorder = responsebody;
        printFullText('my order:${responsebody.toString()}');
        setState(() {
          isDone = true;
        });
        dataService.itemsCart.clear();
        setState((){
        });
      }).catchError((error){
        printFullText(error.toString());
      });
    }

  @override
  void initState() {
    order();

    // FirebaseMessaging.onMessage.listen((message)async{
    //   if (message.data != null){
    //     var jsonMap = jsonDecode(message.data['payload']);
    //     if(message.data['notification_type']=='ORDER_PAID'){
    //
    //       setState(() {
    //         title = "تم الدفع بنجاح";
    //         description = "لقد تمت معالجة طلبك بنجاح";
    //         isDone = false;
    //       });
    //       order().then((value){
    //         Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Order(order:myorder)));
    //       });
    //     }
    //
    //     if(message.data['notification_type']=='ORDER_PAID_FAILED'){
    //
    //       setState(() {
    //         title = "لم يتم الدفع بنجاح";
    //         description = "لقد فشلت معالجة طلبك";
    //         isDone = false;
    //       });
    //       order().then((value){
    //         Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Order(order:myorder)));
    //       });
    //     }
    //   }
    // });
    FirebaseMessaging.instance.getInitialMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    String url = "https://api.canariapp.com/payment/cmi/${widget.refCode}";

    return WillPopScope(
      onWillPop: ()async{
        if(currentIndex==4){
          setState(() {
            url = "https://api.canariapp.com/payment/cmi/${widget.refCode}";
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Payment(refCode:widget.refCode)));
            currentIndex = 0;
          });
        }else{
          setState(() {
            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Order(order:myorder)));
          });}
        return currentIndex==4?false:true;
      },
      child: Scaffold(
        backgroundColor:Colors.white,
        appBar: AppBar(
          elevation:0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('دفع بالبطاقة', style: TextStyle(
              fontSize: 17,
              color: Colors.black, fontWeight: FontWeight.bold),),
          leading: GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Order(order:myorder)));
                     },
              child: Icon(Icons.arrow_back,color: Colors.black)),
        ),
        body:isDone?Stack(
          children: [
            WebView(
              initialUrl:url,
              javascriptMode:JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>{
                JavascriptChannel(
                  name:'messageHandler',
                  onMessageReceived: (JavascriptMessage message) {
                    Map<String, dynamic> data = jsonDecode(message.message);
                     if(data['action']=='ORDER_PAID'){
                             setState(() {
                               title = "تم الدفع بنجاح";
                               description = "لقد تمت معالجة طلبك بنجاح";
                               isDone = false;
                             });
                             order().then((value){
                               Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Order(order:myorder)));
                             });
                     }
                    if(data['action']=='REDIRECT_ORDER'){
                            setState(() {
                              title = "لم يتم الدفع بنجاح";
                              description = "لقد فشلت معالجة طلبك";
                              isDone = false;
                            });
                            order().then((value){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>Order(order:myorder)));
                            });
                    }
                  },)
              },
              onPageStarted:(urlStart) {
                setState(() {
                  _isLoading = true;
                  currentIndex += 1;
                  url = urlStart;
                });
              },
              onPageFinished: (urlStart) {
                setState(() {
                  _isLoading = false;

                });
              },
            ),
            if(_isLoading)
              Center(
                child:CircularProgressIndicator(),
              ),
          ],
        ):Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Icon(title=='تم الدفع بنجاح'?Icons.check_circle:Icons.warning_amber_rounded,size: 150,color:title=='تم الدفع بنجاح'? Colors.green:AppColor,),
               Text(title,style: TextStyle(
                 fontSize: 22,
                 fontWeight: FontWeight.w500
               ),),
              height(10),
              Padding(
                padding: const EdgeInsets.only(left: 50,right: 50),
                child: Text(description,style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
                ),
              ),
              height(25),
              Center(
                child:CircularProgressIndicator(color: Colors.red),
              ),
            ],
          ),
        ),
        //
        // bottomNavigationBar:
      ),
    );
  }
}
