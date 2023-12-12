import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopapp/Layout/shopcubit/shopcubit.dart';

import '../../Layout/HomeLayout/profile.dart';
import '../../Layout/HomeLayout/selectLocation.dart';
import '../../Layout/shopcubit/shopstate.dart';
import '../../shared/components/components.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../widgets/resturantGridl.dart';
import '../../widgets/resturantList.dart';

class OrderDelivery extends StatefulWidget {

  const OrderDelivery({Key key,}) : super(key: key);

  @override
  State<OrderDelivery> createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  String MyLocation = Cachehelper.getData(key: "myLocation");
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ShopCubit()..getStoresData(latitude: latitud==null?27.149890:latitud,longitude: longitud==null?-13.199970:longitud),
        child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = ShopCubit.get(context);
            var search = ShopCubit.get(context).search;
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar:appbar(context,myLocation: MyLocation==null?'اختر موقع':MyLocation,icon: Icons.person,
                      onback: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context)=>SelectLocation(routing: 'homepage',)), (route) => false);
                      },
                      ontap: (){
                        navigateTo(context, Profile());
                      },iconback: Icons.keyboard_arrow_down),
                  body:SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                       Padding(padding: EdgeInsets.only(right:8),child:title(text: 'توصيل مجاني',size: 16,color:Colors.black),),
                        height(20),
                        cubit.stores.length>0?ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 1,
                              );
                            },
                            itemCount:cubit.stores.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = cubit.stores[index];
                              return Padding(
                                padding:EdgeInsets.only(left: 20,right: 20,bottom: 15),
                                child: ResturantGridl(Restaurant: item,id:item['id'],size: 220.0,ispriceLoading:cubit.ispriceLoading,PriceDeliverys: cubit.PriceDeliverys),
                              );
                            }):ListView.separated(
                              separatorBuilder: (context, index) {
                                return width(10);
                              },
                              physics: BouncingScrollPhysics(),
                              itemCount:7,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(alignment: Alignment.topLeft,
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                period: Duration(seconds: 2),
                                                highlightColor: Colors.grey[100],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  height: 125,
                                                  width: double.infinity,

                                                ),
                                              ),
                                            ]),
                                        height(5),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300],
                                            period: Duration(seconds: 2),
                                            highlightColor: Colors.grey[100],
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                'Motlen Chocolate',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                        height(5),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5, bottom: 0),
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                period: Duration(seconds: 2),
                                                highlightColor: Colors.grey[100],
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Text(
                                                    'Sandawiches  italian Fast Food',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFF0A8791),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        height(4),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300],
                                            period: Duration(seconds: 2),
                                            highlightColor: Colors.grey[100],
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4),
                                                    child: Row(children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                        size: 16,
                                                      ),
                                                      width(5),
                                                      Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                      width(5),
                                                      Text(
                                                        "Excellent",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600),
                                                      ),
                                                    ]),
                                                  ),
                                                  width(5),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 10,
                                                        width: 1,
                                                        color: Colors.black,
                                                      ),
                                                      width(5),
                                                      Text(
                                                        '',
                                                        style: TextStyle(
                                                            color: Colors.brown[900],
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    ],
                                                  )

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),



                      ],
                    ),
                  )),
            );
          },
        ),
      );
  }
}
