import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../Layout/HomeLayout/home_page.dart';
import '../../../Layout/shopcubit/shopcubit.dart';
import '../../../Layout/shopcubit/shopstate.dart';
import '../../../class/resturantCategoriesItem.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/remote/cachehelper.dart';
import '../product_detail.dart';

class DetailsMenu extends StatefulWidget {
  final ShopCubit cubit;
  final String name;
  final String slug;
  final String cover;
  final String brandlogo;
  final dynamic price_delivery;
  List<dynamic> cuisines = [];
  List<dynamic> tags = [];
  int id;
   DetailsMenu({Key key,this.cubit, this.cover,
    this.name,
    this.price_delivery,
    this.cuisines,
    this.id,
    this.tags,
    this.brandlogo,
    this.slug,}) : super(key: key);

  @override
  State<DetailsMenu> createState() => _DetailsMenuState();
}

class _DetailsMenuState extends State<DetailsMenu> {
  var price;
  var address;
  double latitud = Cachehelper.getData(key: "latitude");
  double longitud = Cachehelper.getData(key: "longitude");
  String MyLocation = Cachehelper.getData(key: "myLocation");
  List<dynamic> OfferProducts = [];
  List<double>breackPoints = [];
  var productHeight = 120.0;
  int selectCategoryIndex = 0;
  bool isScroller = false;
  final scrollController = ScrollController();

  double resturantInfoHeight = 195 + 52 - kToolbarHeight; //Appbar height
  bool isShow = false;
  bool isExited = false;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  getAllProducts(categories) {
    var products = [];
    for (var category in categories) {
      for (var product in category['products']) {
        products.add(product);
      }
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.cubit.store!=null){
      if(widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList().length > 0){
        var productsid = widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList()[0]['products'];
        var allProducts = getAllProducts(widget.cubit.store['menus']);
        for (int id in productsid){
          allProducts.forEach((product){
            if (product['id'] == id && OfferProducts.where((element) => element['id']==product['id']).toList().length==0){
              OfferProducts.add(product);
            }
          });
        }
      }
      double firstBreackPoint = resturantInfoHeight + 15 + (125 * widget.cubit.store['menus'][0]['products'].length);
      breackPoints.add(firstBreackPoint);
      for(var i = 1;i<widget.cubit.store['menus'].length;i++){
        double breackPoint = breackPoints.last + 15 +(125 * widget.cubit.store['menus'][i]['products'].length);
        breackPoints.add(breackPoint);
      }
      scrollController.addListener((){

        for(var i=0;i<widget.cubit.store['menus'].length;i++){
          if(i==0){
            if((scrollController.offset < breackPoints.first)&(selectCategoryIndex!=0)){
              setState(() {
                selectCategoryIndex =0;
              });
            }
          }else if((breackPoints[i-1]<=scrollController.offset)&(scrollController.offset<breackPoints[i])){
            if(selectCategoryIndex!=i){
              setState(() {
                selectCategoryIndex = i;
              });
            }
          }
        }
        if (scrollController.offset > 150) {
          setState(() {
            isShow = true;
          });
        } else {
          setState(() {
            isShow = false;
          });
        }
      });

    }
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context ,state){},
        builder: (context ,state){

          return Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: Scaffold(
                body: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      toolbarHeight:isShow ? 50:0,
                      elevation: 0,
                      expandedHeight: 0,
                      pinned: true,
                      title: Text(
                        isShow ? '${widget.name}' : '',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.white,

                      actions: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16, right: 5),
                              child: GestureDetector(
                                onTap: () {
                                  print('object');
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                    latitude: latitud,
                                    longitude: longitud,
                                    myLocation: MyLocation,
                                  )), (route) => false);
                                },
                                child: CircleAvatar(
                                    child: Icon(Icons.share,
                                        color: Colors.black, size: 24),
                                    backgroundColor: Colors.white,
                                    minRadius: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                  latitude: latitud,
                                  longitude: longitud,
                                  myLocation: MyLocation,
                                )), (route) => false);
                              },
                              child: CircleAvatar(
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.black, size: 26),
                                  backgroundColor: Colors.white,
                                  minRadius: 22),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SliverPadding(padding:
                    const EdgeInsets.symmetric(horizontal: 0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Container(
                                height: 210,
                                color: Colors.white,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topCenter,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 140,
                                            color: Colors.black,
                                            child: Opacity(
                                              opacity: widget.cubit.store['is_open'] == false
                                                  ? 0.3
                                                  : 1,
                                              child: CachedNetworkImage(
                                                  width: double.infinity,
                                                  imageUrl: '${widget.cover}',
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                        'assets/placeholder.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                  errorWidget: (context, url, error) =>
                                                  const Icon(Icons.error),
                                                  imageBuilder: (context, imageProvider) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10,top: 5),
                                                    child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset: Offset(3, 3),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                                        latitude: latitud,
                                                        longitude: longitud,
                                                        myLocation: MyLocation,
                                                      )), (route) => false);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 6,top: 6),
                                                      child: CircleAvatar(radius: 20,child: Icon(Icons.arrow_back,
                                                          color: Colors.black, size: 24),
                                                        backgroundColor: Colors.white,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Stack(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                                    child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey,
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset: Offset(3, 3),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){

                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10,top: 6),
                                                      child: CircleAvatar(radius: 20,child: Icon(Icons.share,
                                                          color: Colors.black, size: 24),
                                                        backgroundColor: Colors.white,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30,right: 30),
                                      child: Container(
                                        height: 135,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey[300],
                                              width: 0.9
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        width: 65,
                                                        height: 65,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        child:ClipRRect(
                                                          borderRadius: BorderRadius.circular(5),
                                                          child:CachedNetworkImage(
                                                              imageUrl: '${widget.brandlogo}',
                                                              placeholder: (context, url) =>
                                                                  Image.asset('assets/placeholder.png',fit: BoxFit.cover),
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
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    width(4),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('${widget.name}',style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16
                                                        )),
                                                        height(5),
                                                        Wrap(
                                                          crossAxisAlignment: WrapCrossAlignment.start,
                                                          children: [
                                                            Text('${widget.cuisines.map((item) => item['name']).join(' , ')}',style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.grey[400],
                                                            ),)
                                                          ],
                                                        ),
                                                        height(2),

                                                      ],
                                                    )
                                                  ],
                                                ),

                                                if(widget.tags.length>0)
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: Color(0xfffafafa),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 4,left: 8,right: 8,bottom: 6),
                                                        child: Text('جديد',
                                                          style:TextStyle(
                                                              color:Color(0xffff7144),
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.bold
                                                          ),),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text('رسوم التوصيل',style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey[600]
                                                    ),),
                                                    height(5),
                                                    widget.cubit.ispriceLoading? Row(
                                                      children: [
                                                        Text(
                                                            widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price']!=0?'${widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price']} درهم ':"توصيل مجاني",
                                                            style: TextStyle(
                                                                fontSize:11.5,
                                                                fontWeight: FontWeight.bold,color: AppColor)
                                                        ),


                                                        if(widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price_old']!=widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price'])
                                                          width(4),
                                                        if(widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price_old']!=widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price'])
                                                          Text(' ${widget.cubit.PriceDeliverys.where((item)=>item['store_id']==widget.cubit.store['id']).toList()[0]['delivery_price_old']} درهم ',
                                                              style: TextStyle(
                                                                  decoration: TextDecoration.lineThrough,
                                                                  fontSize:10.2,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.grey[400]
                                                              )
                                                          )
                                                      ],
                                                    ):Row(
                                                      children: [
                                                        SpinKitThreeBounce(
                                                          color: Colors.grey[400],
                                                          size: 20.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                    height: 30,
                                                    width: 1,
                                                    color:Colors.grey[300]
                                                ),
                                                Column(
                                                  children: [
                                                    Text('حالة المطعم',style: TextStyle(
                                                        fontSize: 13,
                                                        color:Colors.grey[600]
                                                    ),),
                                                    height(5),
                                                    Text(widget.cubit.store['is_open'] != false?'مفتوح':'مغلق',style: TextStyle(
                                                      fontSize: 11.5,
                                                      fontWeight: FontWeight.bold,

                                                    ),)
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),

                          if(widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList().length > 0)
                          SliverPadding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                            sliver: SliverToBoxAdapter(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(right: 10,top: 10,bottom: 10),
                                        child: Text('${widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList()[0]['ar']['name']}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                     Container(
                                       height: 200,
                                       width: double.infinity,
                                       color: Colors.white,
                                       child:ListView.builder(
                                         physics: BouncingScrollPhysics(),
                                         scrollDirection: Axis.horizontal,
                                           itemCount: OfferProducts.length,
                                           shrinkWrap: true,
                                           itemBuilder: (context,index){
                                             return Padding(
                                               padding: const EdgeInsets.all(8.0),
                                               child: GestureDetector(
                                                 onTap: ()async{
                                                   var totalPrice = await showModalBottomSheet(
                                                       shape: RoundedRectangleBorder(
                                                           borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                       ),
                                                       isScrollControlled: true,
                                                       context: context,
                                                       builder: (context) {
                                                         StoreName = widget.cubit.store['name'];
                                                         StoreId = widget.cubit.store['id'];
                                                         deliveryPrice = widget.price_delivery;
                                                         storeStatus = widget.cubit.store['is_open'];
                                                         widget.cubit.qty = 1;
                                                         return buildProduct(OfferProducts[index],widget.cubit,StoreName,StoreId,deliveryPrice,storeStatus,calculatePrice: calculatePrice(double.tryParse(OfferProducts[index]['price']),int.tryParse(widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList()[0]['config']['percentage'])),offers: widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList()[0]);
                                                       });
                                                   setState(() {
                                                     totalPrice = price;
                                                   });
                                                 },
                                                 child: Container(
                                                   width: 180,
                                                   decoration: BoxDecoration(

                                                       borderRadius: BorderRadius.circular(8),

                                                   ),
                                                   child: Column(
                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                      Container(
                                                        height:110,
                                                        width: 180,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child:OfferProducts[index]['image']==''?
                                                        ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight:Radius.circular(8)),
                                                            child: Image.asset('assets/placeholder.png',fit: BoxFit.cover,)):
                                                        CachedNetworkImage(
                                                            imageUrl: '${OfferProducts[index]['image']}',
                                                            placeholder: (context, url) =>
                                                                ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                    child: Image.asset('assets/placeholder.png',fit: BoxFit.cover,width: 90,height: 90,)),
                                                            errorWidget: (context, url, error) => ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight:Radius.circular(8)),
                                                                child: Image.asset('assets/placeholder.png',fit: BoxFit.cover,)),
                                                            imageBuilder: (context, imageProvider){
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        ),
                                                      ),
                                                       Padding(padding: EdgeInsets.only(right: 8,top: 10),
                                                       child: Column(
                                                         mainAxisAlignment: MainAxisAlignment.start,
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Text('${OfferProducts[index]['name']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                                           height(5),
                                                           Padding(
                                                             padding: const EdgeInsets.only(left: 5),
                                                             child: Row(
                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                               children:[
                                                                 Text('${calculatePrice(double.tryParse(OfferProducts[index]['price']),int.tryParse(widget.cubit.store['offers'].where((e)=>e['type'] != 'freeDeliveryFirstOrder').toList()[0]['config']['percentage']))} درهم ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color:AppColor),),
                                                                 Padding(
                                                                   padding: const EdgeInsets.only(top: 5),
                                                                   child: Text('${OfferProducts[index]['price']} درهم ',
                                                                     style: TextStyle(fontSize: 11,fontWeight: FontWeight.normal,color: Colors.grey[400],decoration: TextDecoration.lineThrough),),
                                                                 ),

                                                               ],
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                       )
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             );
                                           }),
                                     )
                                    ]),
                              ),
                            ),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: ResturantCategoriesItem(
                                isShow :isShow,
                                cubit: widget.cubit,
                                selectedIndex: selectCategoryIndex,
                                onchanged: (int index) {
                                  if (selectCategoryIndex != index) {
                                    int totalItems = 0;
                                    for (var i = 0; i < index; i++) {
                                      totalItems += widget.cubit.store['menus'][i]['products'].length;
                                    }
                                    scrollController.animateTo(
                                        resturantInfoHeight +
                                            (130 * totalItems) +
                                            (20 * index),
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }
                                  setState(() {
                                    selectCategoryIndex = index;
                                  });
                                }),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            sliver: SliverToBoxAdapter(
                              child:Column(
                                children: [
                                  Container(
                                    color: Colors.grey[100],
                                    child: Column(
                                      children:
                                      [
                                        ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget.cubit.store['menus'].length,
                                            itemBuilder: (context, int index) {
                                              return Padding(
                                                padding:
                                                const EdgeInsets.only(bottom: 10, top: 0),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 16,right: 10),
                                                        child: Text(
                                                          '${capitalize('${widget.cubit.store['menus'][index]['name']}')}',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                      height(10),
                                                      Column(
                                                        children: [
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              itemCount: widget.cubit.store['menus'][index]['products'].length,
                                                              itemBuilder: (BuildContext context, productindex) {
                                                                var product = widget.cubit.store['menus'][index]['products'][productindex];
                                                                var contain = dataService.itemsCart.where((element) =>
                                                                element['id'] == product['id']).toList();
                                                                if (contain.isEmpty) {
                                                                  isExited = false;
                                                                } else {
                                                                  isExited = true;
                                                                }

                                                                return Container(

                                                                  child:
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Container(
                                                                        height:productHeight,
                                                                        color: Colors.white,
                                                                        child: InkWell(
                                                                          onTap: () async {
                                                                            if (product['modifierGroups'].length == 0) {
                                                                              var totalPrice = await showModalBottomSheet(
                                                                                  shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                                                  ),
                                                                                  isScrollControlled: true,
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    StoreName = widget.cubit.store['name'];
                                                                                    StoreId = widget.cubit.store['id'];
                                                                                    deliveryPrice = widget.price_delivery;
                                                                                    storeStatus = widget.cubit.store['is_open'];
                                                                                    widget.cubit.qty = 1;
                                                                                    return buildProduct(product,widget.cubit,StoreName,StoreId,deliveryPrice,storeStatus);
                                                                                  });
                                                                              setState(() {
                                                                                totalPrice = price;
                                                                              });
                                                                            } else {
                                                                              StoreName = widget.cubit.store['name'];
                                                                              StoreId = widget.cubit.store['id'];
                                                                              deliveryPrice = widget.price_delivery;
                                                                              storeStatus = widget.cubit.store['is_open'];
                                                                              var totalPrice = await navigateTo(context,ProductDetail(
                                                                                id: StoreId,
                                                                                StoreName: StoreName,
                                                                                DeliveryPrice: deliveryPrice,
                                                                                dishes: product,
                                                                                storeStatus: storeStatus,
                                                                              ));
                                                                              setState(() {
                                                                                totalPrice = price;
                                                                              });
                                                                            }
                                                                          },
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              isExited
                                                                                  ? Padding(
                                                                                padding: const EdgeInsets.only(top: 15),
                                                                                child: Container(
                                                                                    height: 90,
                                                                                    width: 2.7,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(50),
                                                                                      color: AppColor,
                                                                                    )),
                                                                              )
                                                                                  : height(0),
                                                                              width(6),
                                                                              isExited
                                                                                  ? Padding(
                                                                                padding: EdgeInsets.only(
                                                                                  top: 20,
                                                                                ),
                                                                                child: Container(
                                                                                  height: 23,
                                                                                  width: 23,
                                                                                  decoration: BoxDecoration(color: AppColor, shape: BoxShape.circle, boxShadow: [
                                                                                    BoxShadow(color: Colors.grey[300], offset: Offset(2, 1), blurRadius: 2, spreadRadius: 1)
                                                                                  ]),
                                                                                  child: Center(
                                                                                      child: contain.length > 0
                                                                                          ? Text(
                                                                                        'x${contain[0]['quantity']}',
                                                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                                                                                      )
                                                                                          : height(0)),
                                                                                ),
                                                                              )
                                                                                  : height(0),
                                                                              width(4),
                                                                              Expanded(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      product['name'] == null ? '' : '${product['name']}',
                                                                                      maxLines: 2,
                                                                                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    height(5),
                                                                                    Text(
                                                                                      product['description'] == null ? '' : '${product['description']}',
                                                                                      maxLines: 2,
                                                                                      style: TextStyle(fontSize: 12.5, color: Colors.grey[600], fontWeight: FontWeight.normal),
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                    height(2),
                                                                                    Text.rich(TextSpan(children: [
                                                                                      TextSpan(
                                                                                        text: '${product['price']} درهم ',
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.w400,
                                                                                          color:Colors.grey[600],
                                                                                          fontSize: 14,
                                                                                        ),
                                                                                      ),
                                                                                    ])),
                                                                                    height(9),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              width(15),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Container(
                                                                                  width: 120,
                                                                                  height: 120,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                    child: product['image'] == ''
                                                                                        ? height(0)
                                                                                        : CachedNetworkImage(
                                                                                        imageUrl: '${product['image']}',
                                                                                        placeholder: (context, url) => Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                        imageBuilder: (context, imageProvider) {
                                                                                          return Container(
                                                                                            decoration: BoxDecoration(
                                                                                              image: DecorationImage(
                                                                                                image: imageProvider,
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        }),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      height(3),
                                                                      Container(
                                                                        height:0.5,
                                                                        width:double.infinity,
                                                                        color:Colors.grey[350],
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            )
                          ),
                          SliverPadding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    widget.cubit.store['menus'].length == 0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'نحن نعمل على ادراج هذا المتجر ، تعال قريبًا',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                height(20),
                                                LinearProgressIndicator(
                                                    color: AppColor,
                                                    backgroundColor:
                                                        Color(0xFFFFCDD2)),
                                              ],
                                            ),
                                          )
                                        : SizedBox(height: 0),

                                  ]),
                            ),
                          ),

                  ],
                )
              ),
            ),
          );
        },
      ),
    );
  }
  Container devider() {
    return Container(
      height: 8,
      color: Colors.grey[100],
      width: double.infinity,
    );
  }

  Widget buildProduct(product,cubit,StoreName,StoreId,deliveryPrice,storeStatus,{double calculatePrice,offers}){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            product['image']!=''? Container(
              height: 300,
              width: double.infinity,
              child:product['image']==''?
              Image.asset('assets/placeholder.png',):
              CachedNetworkImage(
                  imageUrl: '${product['image']}',
                  placeholder: (context, url) =>
                      Image.asset('assets/placeholder.png',fit: BoxFit.cover,),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover
                        ),
                      ),
                    );
                  }
              ),


            ):height(0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  setState((){
                    Navigator.pop(
                        context, '${cubit.getTotalPrice()}');
                  });
                },
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close,color: Colors.black,size: 25)),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
          child: Text('${product['name']}',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
        ),
        product['description']!=null?   Padding(
          padding: const EdgeInsets.only(left: 15,top: 20,right: 15),
          child: Column(

            children: [
              Text(
                '${product['description']}',
                style:
                TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ):height(0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            calculatePrice!=null? Padding(
              padding: const EdgeInsets.only(left: 15,top: 5,right: 15,bottom: 15),
              child: Text('${product['price']} درهم ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color:Colors.grey[400],decoration: TextDecoration.lineThrough),),
            ):height(0),
            Padding(
              padding: const EdgeInsets.only(left: 15,top: 5,right: 15,bottom: 15),
              child: Text('${calculatePrice==null?product['price']:calculatePrice} درهم ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal,color: Colors.black),),
            ),

          ],
        ),

        height(20),
        StatefulBuilder(builder: (context,setState){
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            height: 75,
            child: Padding(
              padding: const EdgeInsets.only(right: 15,left: 15,bottom: 10,top: 10),
              child: GestureDetector(
                onTap: (){
                  StoreName = StoreName;
                  StoreId = StoreId;
                  deliveryPrice = deliveryPrice;
                  cubit.addToCart(
                      product:product,
                      Qty:cubit.qty,
                      productStoreId:StoreId,
                      attributes:[],
                      storeStats: storeStatus,
                      offers:offers,
                      storeName:StoreName,
                  );
                  if(cubit.isinCart){
                    Navigator.pop(context, '${cubit.getTotalPrice()}');
                  }
                  if(cubit.isinCart==false){
                    print('${cubit.isinCart}');
                    dataService.itemsCart.clear();
                    dataService.productsCart.clear();
                    cubit.addToCart(
                        product:product,
                        Qty:cubit.qty,
                        productStoreId:StoreId,
                        attributes:[],
                        storeStats: storeStatus,
                        offers:offers,
                        storeName:StoreName,
                    );
                    if(cubit.isinCart){
                      Navigator.pop(context, '${cubit.getTotalPrice()}');
                    }
                  }


                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:AppColor,
                        ),
                        width: double.infinity,
                        child: Center(child: Text('أضف إلى السلة',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
                        )
                        ),
                      ),
                    ),
                    width(5),
                    StatefulBuilder(builder: (context,setState){
                      return Expanded(
                        child: Container(
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color:Colors.grey[100],
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Icon(Icons.remove,color: Colors.black,size: 30,),
                                ),
                                onTap: (){
                                  cubit.minus();
                                  setState((){});
                                },
                              ),
                              width(20),
                              Text('${cubit.qty}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
                              width(20),
                              GestureDetector(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Icon(Icons.add,color: Colors.black,size: 30,),
                                ),
                                onTap: (){
                                  cubit.plus();
                                  setState((){});
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          );
        }),

      ],
    );
  }

double calculatePrice(price,percentage){
  percentage = percentage / 100;
  return price - (price * percentage);
}
}
