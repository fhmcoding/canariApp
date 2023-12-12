import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shopapp/Layout/HomeLayout/layoutPage.dart';
import 'package:shopapp/modules/pages/serviceIosoff.dart';
import 'package:shopapp/modules/pages/serviceOff.dart';
import 'package:shopapp/shared/components/constants.dart';
import 'dart:io';
import '../../Layout/HomeLayout/home_page.dart';
import '../../Layout/HomeLayout/selectLocation.dart';
import '../../Layout/shopcubit/shopcubit.dart';
import '../../Layout/shopcubit/shopstate.dart';
import '../../shared/network/remote/cachehelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  AnimationController controller;

  bool statusServiceIos = false;
  String ServicetimingStart = null;
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  String MyLocation = Cachehelper.getData(key: "myLocation");

  Future<bool>ServiceStatus()async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    bool remoteConfigVersion = remoteConfig.getBool('serviceStatus');
    serviceStatus = remoteConfigVersion;
    return remoteConfigVersion;

  }

  Future<bool>IsOtpActive()async{
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    bool remoteConfigVersion = remoteConfig.getBool('isOtpActive');
    isOtpActive = remoteConfigVersion;
    print('isOtpActive:${isOtpActive}');
    return remoteConfigVersion;

  }


  Future<bool>ServiceIosStatus() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    bool remoteConfigStatus = remoteConfig.getBool('statusServiceIos');
     if(remoteConfigStatus == false){
       ServicetimingStart = remoteConfig.getString('ServicetimingStart');
       print(remoteConfig.getString('ServicetimingStart'));

     }
    statusServiceIos = remoteConfigStatus;
    return remoteConfigStatus;

  }



  TimeConfig() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    TimeStart = remoteConfig.getString('timeStart');
    print(TimeStart);
    TimeEnd = remoteConfig.getString('timeEnd');
    print(TimeEnd);
  }

  AppServices() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    Appservice = remoteConfig.getBool('appServices');
    setState(() {

    });



  }

  PaymentAvibalty() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    IsPaymentActive = remoteConfig.getBool('isPaymentactive');
    setState(() {

    });



  }
  StartWith() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    setState(() {
      Startwith = remoteConfig.getBool('startwithLocation');
    });



  }

  CouponActiv() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    CouponActive = remoteConfig.getBool('CouponActive');
    print('-----------------------------------------');
    print('object');
    print('coupon:${CouponActive}');
    print('-----------------------------------------');




  }

  ShareActiv() async {
    RemoteConfig remoteConfig = RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 60),
        minimumFetchInterval: Duration(seconds: 1)
    ));
    await remoteConfig.fetchAndActivate();
    shareActive = remoteConfig.getBool('shareActive');
    print('-----------------------------------------');
    print('object');
    print('coupon:${shareActive}');
    print('-----------------------------------------');
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      IsOtpActive();
      PaymentAvibalty();
      AppServices();
      StartWith();
      CouponActiv();
      ServiceStatus();
      ServiceIosStatus();
      TimeConfig();
      ShareActiv();
    });
    controller = AnimationController(vsync: this,duration: Duration(seconds:3));
    controller.addStatusListener((status)async {
      if (status==AnimationStatus.completed){
        if(Platform.isAndroid){
          if(Appservice){
            if(latitud==null){
              if(Startwith){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>SelectLocation(
                      routing: "homepage",
                    )), (route) => false);
              }else{
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>
                        LayoutPage()), (route) => false);
              }
            }else{
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context)=>
                      LayoutPage()), (route) => false);
            }
          }else{
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>ServiceOff()), (route) => false);
          }
        }
        else if(Platform.isIOS){
          if(statusServiceIos){
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>
                    MyHomePage(
                      latitude: latitude,
                      longitude: longitude,
                      myLocation: myLocation,
                    )), (route) => false);
          }else{
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context)=>ServiceOff()), (route) => false);
          }

        }
        controller.reset();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    print(Appservice);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return
      BlocProvider(
        create: (BuildContext context) => ShopCubit(),
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context,state){

          },
          builder: (context,state){
            return Scaffold(
                body:
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: AppColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Lottie.asset('assets/nnn.json',
                              height: 200,
                              repeat: false,
                              controller: controller,
                              onLoaded:(LottieComposition){
                                controller.forward();
                                setState(() {

                                });
                              }),
                        ],
                      ),
                    )
                  ],
                )
            );
          },
        ),
      );
  }
}
