import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/HomeLayout/home_page.dart';
import 'package:shopapp/Layout/HomeLayout/profile.dart';
import 'package:shopapp/Layout/HomeLayout/selectLocation.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/widgets/categories.dart';
import '../../LayoutMarket/layout_market.dart';
import '../../localization/demo_localization.dart';
import '../../modules/pages/RestaurantPage/restaurant_page.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../widgets/sliders.dart';
import '../shopcubit/shopcubit.dart';
import '../shopcubit/shopstate.dart';

class LayoutPage extends StatefulWidget {
  final String myLocation;
  final double latitude;
  final double longitude;
  const LayoutPage({Key key, this.myLocation, this.latitude, this.longitude}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  var price;
  String MyLocation = Cachehelper.getData(key: "myLocation");
  HashSet selectFilters = new HashSet();
  bool isServicesLoading = true;

  List services = [];
  int SelectedIndex = 0;
  Future<void> GetServices() async{
    setState(() {
      isServicesLoading = false;
    });
    String access_token = Cachehelper.getData(key: "token");
    http.Response response = await http.get(Uri.parse('https://api.canariapp.com/v1/client/services'),
      headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${access_token}'},
    ).then((value){
      var responsebody = jsonDecode(value.body);
      printFullText(responsebody.toString());
      setState(() {
        isServicesLoading = true;
        services = responsebody;
      });
    }).catchError((onError){

    });
    return response;
  }

  List FakeServices = [{
    "image":"https://images.deliveryhero.io/image/fd-my/LH/cr42-listing.jpg"
  },{
    "image":"https://images.deliveryhero.io/image/talabat/launcher/grocery.png?v=2"
  },{
    "image":"https://images.deliveryhero.io/image/fd-my/LH/uu3x-listing.jpg"
  },{
    "image":"https://images.deliveryhero.io/image/talabat/launcher/pharmacy.png?v=2"
  },];

  List Offers = [{
    "image":"https://images.deliveryhero.io/image/fd-my/LH/cr42-listing.jpg"
  },{
    "image":"https://images.deliveryhero.io/image/talabat/launcher/grocery.png?v=2"
  },{
    "image":"https://images.deliveryhero.io/image/fd-my/LH/uu3x-listing.jpg"
  },{
"image":"https://images.deliveryhero.io/image/talabat/launcher/pharmacy.png?v=2"
},];
  @override
  void initState() {
    GetServices();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit = ShopCubit.get(context);
          return Scaffold(
            backgroundColor:Colors.white,
            appBar:appbar(context,myLocation: MyLocation==null?'اختر موقع':MyLocation,icon: Icons.person,
                onback: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SelectLocation(routing: 'homepage',)),(route) => false);
                },
                ontap: (){navigateTo(context, Profile());},iconback: Icons.keyboard_arrow_down),
            body: SingleChildScrollView(
              // physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(20),
                 isServicesLoading?
                 Center(
                   child:Padding(
                     padding: const EdgeInsets.only(left: 10,right: 15,top: 10),
                     child: Wrap(
                       runSpacing:15,
                       spacing:15,
                       children:[
                         ...services.map((e) =>Column(
                           children:[
                             Stack(
                               children: [
                                 Stack(
                                   alignment: Alignment.topLeft,
                                   children:[
                                     GestureDetector(
                                       onTap: (){
                                         if(e['status']=='published'){
                                           if(e['service_id']=="grocery"){
                                             navigateTo(context,LayoutMarket());
                                           }else{
                                             service_type = e['service_id'];
                                             navigateTo(context,MyHomePage(
                                               myLocation:widget.myLocation,
                                               longitude:widget.longitude,
                                               latitude:widget.latitude,
                                               category:service_type,
                                             ));
                                           }
                                         }
                                       },
                                       child: Container(
                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color:Color(0xFFf3f4f5)),
                                         height: 110,
                                         width: 110,
                                         child:Image.network('${e['image']}'),
                                       ),
                                     ),
                                     e['status']=='published'?height(0):Padding(
                                       padding: const EdgeInsets.only(right: 5,top:7,left:5),
                                       child: Icon(Icons.lock_rounded,size: 20, ),
                                     )
                                   ],

                                 ),

                               ],
                             ),
                             height(10),
                             Text(
                               '${e['name']}',
                               style: TextStyle(
                                   fontWeight: FontWeight.normal,
                                   color: Color(0xFF000000),
                                   fontSize: 15),
                             ),
                           ],
                         ))
                       ],
                     ),
                   ),
                 )
                     :Center(
                    child:Padding(
                      padding: const EdgeInsets.only(left: 10,right: 15,top: 10),
                      child: Wrap(
                        runSpacing: 15,
                        spacing: 15,
                        children:[
                         ...FakeServices.map((e) => Column(
                           children:[
                             Stack(
                               children: [
                                 Stack(
                                   alignment: Alignment.topLeft,
                                   children:[
                                     Shimmer.fromColors(
                                       baseColor: Colors.grey[200],
                                       period: Duration(seconds: 2),
                                       highlightColor: Colors.grey[100],
                                       child: Container(
                                         decoration:BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(5),
                                         ),
                                         height: 110,
                                         width: 110,
                                       ),
                                     ),
                                   ],

                                 ),

                               ],
                             ),
                             height(10),
                             Shimmer.fromColors(
                               baseColor: Colors.grey[200],
                               highlightColor: Colors.grey[100],
                               child: Container(
                                 height:5,
                                 width: 100,
                                 color: Colors.grey,
                                 child: Text(
                                   '',
                                   style: TextStyle(
                                       fontWeight: FontWeight.normal,
                                       color: Color(0xFF000000),
                                       fontSize: 15),
                                 ),
                               ),
                             ),
                           ],
                         ))
                        ],
                      ),
                    ),
                  ),

                  height(25),
                  Padding(
                    padding: const EdgeInsets.only(right: 20,left: 15),
                    child: Container(
                      height:100,
                      width:double.infinity,
                      decoration: BoxDecoration(
                        color:Color(0xffeef2f5),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child:ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                              imageUrl: 'https://api.canariapp.com//media//703//canari-slayder-02-(1).jpg',
                              placeholder: (context, url) =>
                                  Image.asset('assets/placeholder.png',fit:BoxFit.cover,),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageBuilder: (context, imageProvider){
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,

                                    ),
                                  ),
                                );
                              }
                          ),),
                    ),
                  ),
                  height(14),
                  Padding(
                    padding: const EdgeInsets.only(right:5),
                    child: title(text:'العروض اليومية',size: 16,color:Colors.black),
                  ),
                  height(10),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      height:200,
                      width:double.infinity,
                      child:ListView.builder(
                           shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: Offers.length,
                          itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 160,
                            width: 135,
                            decoration: BoxDecoration(
                              color:Color(0xffeef2f5),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network('${Offers[index]['image']}',fit: BoxFit.cover)),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
