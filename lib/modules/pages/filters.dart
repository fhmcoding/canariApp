import 'dart:collection';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/shared/components/components.dart';
import '../../Layout/HomeLayout/profile.dart';
import '../../Layout/HomeLayout/selectLocation.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../widgets/resturantGridl.dart';

class Filters extends StatefulWidget {
  final Categories;
  var text;
   Filters({Key key,  this.text,this.Categories}) : super(key: key);

  @override
  State<Filters> createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {



  HashSet selectCategories = new HashSet();
  List filters = [];
  @override
  Widget build(BuildContext context) {
    String MyLocation = Cachehelper.getData(key: "myLocation");
    double latitud = Cachehelper.getData(key: "latitude");
    double longitud = Cachehelper.getData(key: "longitude");
    return BlocProvider(
      create: (context)=>ShopCubit()..FilterData(latitude: latitud,longitude: longitud,text: widget.text),
     child:  BlocConsumer<ShopCubit,ShopStates>(
       listener:(context,state){
          if(state is GetFilterDataSucessfulState){
            filters = state.filters;
          }
       },
       builder:(context,state){
         var cubit = ShopCubit.get(context);
         return Directionality(
           textDirection: TextDirection.rtl,
           child:
           StreamBuilder<ConnectivityResult>(
             stream: Connectivity().onConnectivityChanged,
             builder: (context,snapshot){
               return Scaffold(
                   bottomSheet:snapshot.data==ConnectivityResult.none?buildNoNetwork():height(0),
                   backgroundColor: Colors.white,
                   appBar:appbar(context,myLocation: MyLocation==null?'اختر موقع':MyLocation,icon: Icons.person,
                       onback: (){
                         Navigator.of(context).pushAndRemoveUntil(
                             MaterialPageRoute(builder: (context)=>SelectLocation(routing: 'homepage',)), (route) => false);
                       },
                       ontap: (){
                         navigateTo(context, Profile());
                       },iconback: Icons.keyboard_arrow_down),
                   body:cubit.isloading? SingleChildScrollView(
                     physics: BouncingScrollPhysics(),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 15,right: 15),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               SearchBarAndFilter(context),
                             ],
                           ),
                         ),
                         height(5),

                         Padding(
                     padding: const EdgeInsets.only(left: 15,right: 15),
                     child: FilterChip(
                         labelPadding:EdgeInsets.only(right: 15,left: 10) ,
                         labelStyle:TextStyle(fontSize: 12) ,
                         backgroundColor: Colors.white,
                         side: BorderSide(
                           color: Colors.grey[350],
                           width: 1,
                         ),
                         avatar: Icon(Icons.close,size: 15,),
                         label: Text('${widget.text}',),
                         onSelected: (s){
                           setState(() {
                             widget.text = "";
                             cubit.FilterData(
                               longitude: longitud,
                               latitude: latitud,
                               text: widget.text,
                             );
                           });
                           Navigator.pop(context);
                         }),
                   ),
                         Padding(
                           padding: const EdgeInsets.only(left: 15,top: 10,bottom: 10,right: 18),
                           child: Text('نتائج (${filters.length}) ',style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 15
                           ),),
                         ),
                         height(5),
                         filters.length==0?Padding(
                           padding: const EdgeInsets.only(top: 50),
                           child: Column(
                             children: [
                               Image.network('https://canariapp.com/_nuxt/img/binoculars.9681313.png',),
                               Padding(
                                 padding: const EdgeInsets.only(left: 25,right: 25,top: 10),
                                 child: Text('لا يوجد مطعم متوفر بهذا الفلتر حاول مرة أخرى بفلتر مختلف',style: TextStyle(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold,
                                 ),
                                   textAlign: TextAlign.center,
                                 ),
                               ),
                             ],
                           ),
                         ):height(0),
                         ListView.builder(
                             physics: NeverScrollableScrollPhysics(),
                             shrinkWrap: true,
                             itemBuilder: (context,index){
                               return Padding(
                                 padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
                                 child: ResturantGridl(Restaurant:filters[index],id:filters[index]['id'],size: 220.0,ispriceLoading: cubit.ispriceLoading,PriceDeliverys:cubit.PriceDeliverys),
                               );
                             },itemCount: filters.length)
                       ],
                     ),
                   ): SingleChildScrollView(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 15,right: 15),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               SearchBarAndFilter(context),
                             ],
                           ),
                         ),
                         height(20),

                         Padding(
                           padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15,right: 15),
                           child: Shimmer.fromColors(
                             baseColor: Colors.grey[300],
                             period: Duration(seconds: 2),
                             highlightColor: Colors.grey[100],
                             child: Container(
                               height: 15,
                               color: Colors.white,
                               child: Text('Result (${filters.length})',style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 15
                               ),),
                             ),
                           ),
                         ),

                         ListView.builder(
                             shrinkWrap: true,
                             itemCount: 5,
                             itemBuilder: (context,index){
                               return Padding(
                                 padding: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                                 child:
                                 Container(
                                   decoration: BoxDecoration(
                                     color: Colors.white,
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                   width: double.infinity,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Stack(alignment: Alignment.topLeft, children: [
                                         Shimmer.fromColors(
                                           baseColor: Colors.grey[300],
                                           period: Duration(seconds: 2),
                                           highlightColor: Colors.grey[100],
                                           child: Container(
                                             height: 125,
                                             width: double.infinity,
                                             decoration: BoxDecoration(
                                               color: Colors.grey,
                                               borderRadius: BorderRadius.circular(5),
                                             ),
                                             child: ClipRRect(
                                               borderRadius: BorderRadius.circular(5),

                                             ),
                                           ),
                                         ),


                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Shimmer.fromColors(
                                             baseColor: Colors.grey[300],
                                             period: Duration(seconds: 2),
                                             highlightColor: Colors.grey[100],
                                             child: Container(
                                                 height: 65,
                                                 width: 65,
                                                 decoration: BoxDecoration(
                                                     color: Colors.grey,
                                                     borderRadius: BorderRadius.circular(5),
                                                     border: Border.all(
                                                       color: Colors.grey,
                                                       width: 2,
                                                     )),
                                                 child: ClipRRect(
                                                   borderRadius: BorderRadius.circular(5),
                                                   child: Image.network('',fit: BoxFit.cover,),)
                                             ),
                                           ),
                                         ),
                                       ]),
                                       height(10),
                                       Padding(
                                         padding:EdgeInsets.only(left: 12,bottom: 10),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Shimmer.fromColors(
                                               baseColor: Colors.grey[300],
                                               period: Duration(seconds: 2),
                                               highlightColor: Colors.grey[100],
                                               child:  Container(
                                                 width: 180,
                                                 color: Colors.grey,
                                                 child: Text(
                                                   '25 % off entire menu',
                                                   style:TextStyle(
                                                       fontWeight: FontWeight.w400,
                                                       color: Colors.red,
                                                       fontSize: 11.8),
                                                 ),
                                               ),
                                             ),

                                             height(5),
                                             Shimmer.fromColors(
                                               baseColor: Colors.grey[300],
                                               period: Duration(seconds: 2),
                                               highlightColor: Colors.grey[100],
                                               child:  Container(
                                                 width: 200,
                                                 color: Colors.grey,
                                                 child: Text(
                                                   '25 % off entire menu',
                                                   style:TextStyle(
                                                       fontWeight: FontWeight.w400,
                                                       color: Colors.red,
                                                       fontSize: 11.8),
                                                 ),
                                               ),
                                             ),
                                             height(5),
                                             Shimmer.fromColors(
                                               baseColor: Colors.grey[300],
                                               period: Duration(seconds: 2),
                                               highlightColor: Colors.grey[100],
                                               child: Container(
                                                 color: Colors.grey,
                                                 child: Text(
                                                   '25 % off entire menu',
                                                   style:TextStyle(
                                                       fontWeight: FontWeight.w400,
                                                       color: Colors.red,
                                                       fontSize: 11.8),
                                                 ),
                                               ),
                                             ),
                                             // height(9),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               );
                             })
                       ],
                     ),
                   )
               );
             },

           ),
         );
       },
     )
    );
  }
   buildFilter({HashSet selectFilters, List categories}){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(left:15,top: 20,right: 10),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            //
            // Padding(
            //   padding: const EdgeInsets.only(left: 7,top: 10),
            //   child: Text("مرشحات شعبية",style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold
            //   ),),
            // ),
            // height(15),
            // ...Popular_Filters.map((e) {
            //   return
            //     StatefulBuilder(
            //       builder:(context,state){
            //         return GestureDetector(
            //           onTap: () {
            //             state(() {
            //               if (selectFilters.contains(e)) {
            //                 selectFilters.remove(e);
            //               } else {
            //                 selectFilters.add(e);
            //               }
            //               print(selectFilters);
            //             });
            //           },
            //           child: Padding(
            //             padding: const EdgeInsets.only(left: 10,right: 15,top: 10,bottom: 10),
            //             child: Container(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text('${e}',style: TextStyle(
            //                       color: Color(0xFF828894),
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.w500
            //                   ),),
            //                   Icon(selectFilters.contains(e)?Icons.check_box:Icons.check_box_outline_blank,color:selectFilters.contains(e)?Colors.red:Color(0xFF828894)),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //     );
            // }),
            Padding(
              padding: const EdgeInsets.only(left: 7,top: 15),
              child: Text("فئات",style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),),
            ),
            height(15),

            ...widget.Categories.map((e) {
              return StatefulBuilder(
                  builder:(context,state){
                    return GestureDetector(
                      onTap: () {
                        state(() {
                          if (selectFilters.contains(e['name'])) {
                            selectFilters.remove(e['name']);
                          } else {
                            selectFilters.add(e['name']);
                          }
                          print(selectFilters);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 15,top: 10,bottom: 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${e['name']}',style: TextStyle(
                                  color: Color(0xFF828894),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                              ),
                              Icon(selectFilters.contains(e['name'])?Icons.check_box:Icons.check_box_outline_blank,color:selectFilters.contains(e['name'])?Colors.red:Color(0xFF828894)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
            }),
          ],
        ),
      ),
    );
  }
}
