// TextButton(onPressed: (){
//   setState(() {
//     mainAxisSize = MainAxisSize.min;
//     isLiked = false;
//     isunLiked = false;
//   });
//      showModalBottomSheet(
//        backgroundColor: Colors.grey[50],
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(10))
//         ),
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context ,Setstate){
//               return Column(
//                 mainAxisSize: mainAxisSize,
//                 children: [
//                 isNext?
//                 isDrivedRate==true&&isRestaurantRate==true?
//                 Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(onPressed: (){
//                           Navigator.of(context).pop();
//                         }, icon: Icon(Icons.close)),
//                         TextButton(onPressed: (){
//                           Setstate((){
//                            Navigator.of(context).pop();
//                           });
//
//                         }, child:Text('Skip',style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),)),
//
//                       ],
//                     ),
//
//                     Column(
//                       children: [
//                         Container(
//                           height: 450,
//                           width: 370,
//                           color: Colors.transparent,
//                           child: Container(
//                             height:450,
//                             child: Stack(
//                               children: [
//                                 Align(
//                                   alignment:AlignmentDirectional.bottomCenter,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 25,right: 15,bottom: 20,top: 55),
//                                     child: Container(
//                                       height: 400,
//                                       decoration: BoxDecoration(
//                                         color:Colors.white,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey[300],
//                                             blurRadius: 3,
//                                             spreadRadius: 1,
//                                             offset: Offset(1,2),
//                                           ),
//                                         ],
//                                         borderRadius: BorderRadius.circular(7),
//                                       ),
//                                       width: double.infinity,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(top: 50),
//                                         child: Column(
//                                           children: [
//                                             height(30),
//                                             Text('خدمة عملاء',style: TextStyle(
//                                                 fontSize: 18, fontWeight: FontWeight.bold),),
//                                             height(30),
//                                             Padding(
//                                               padding: const EdgeInsets.only(left: 25,right: 25),
//                                               child: Text('شكرا لمشاركتنا رايك ونحن سعداء بتقديم لك دائما افضل ',
//                                                 style:TextStyle(
//                                                     height: 1.7,
//                                                     fontSize: 16,
//                                                     color: Colors.grey[500],
//                                                     fontWeight: FontWeight.normal
//                                                 ),
//                                                 textAlign: TextAlign.center,),
//                                             ),
//                                             height(50),
//                                             Padding(
//                                               padding: const EdgeInsets.only(left: 35,right: 35,top: 15),
//                                               child: GestureDetector(
//                                                 onTap:()async{
//                                                   await http.post(
//                                                       Uri.parse('https://api.canariapp.com/v1/client/reviews'),
//                                                       headers:{'Content-Type':'application/json','Accept':'application/json',
//                                                         'Authorization': 'Bearer ${access_token}'},
//                                                               body: jsonEncode(
//                                                                   {
//                                                                     "order_id":"804",
//                                                                     "rate":7,
//                                                                     "description":null,
//                                                                     "reviewedable":"store"
//                                                                   }
//                                                                   )
//                                                   ).then((value){
//                                                     print(value.body);
//                                                   });
//                                                   Setstate(() {
//                                                     isunLiked = true;
//                                                     isDrivedRate = true;
//
//                                                     print(isunLiked);
//                                                   });
//                                                   Setstate((){
//
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   height: 55,
//                                                   width: double.infinity,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.green,
//                                                       borderRadius: BorderRadius.circular(5)
//                                                   ),
//                                                   child:Center(
//                                                     child:Text('متابعة',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),),
//                                 Align(
//                                   alignment:AlignmentDirectional.topCenter,
//                                   child: Container(
//                                       height: 100,
//                                       width: 100,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: Colors.blue,
//                                       ),
//                                       child:ClipRRect(
//                                         borderRadius: BorderRadius.circular(50.0),
//                                         child: Image.asset('assets/logo.jpg',fit:BoxFit.cover)
//                                       )
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//
//                       ],
//                     )
//
//                   ],
//                 ):
//                 Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(onPressed: (){}, icon: Icon(Icons.close)),
//                         TextButton(onPressed: (){
//                           Setstate((){
//                             print(isRestaurantRate);
//                           });
//
//                         }, child:Text('Skip',style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),)),
//
//                       ],
//                     ),
//                   isDrivedRate?
//                    Column(
//                       children: [
//                           Container(
//                            height: 450,
//                            width: 370,
//                            color: Colors.transparent,
//                             child: Container(
//                               height:450,
//                               child: Stack(
//                                 children: [
//                                     Align(
//                                       alignment:AlignmentDirectional.bottomCenter,
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(left: 25,right: 15,bottom: 20,top: 55),
//                                       child: Container(
//                                       height: 400,
//                                       decoration: BoxDecoration(
//                                       color:Colors.white,
//                                       boxShadow: [
//                                        BoxShadow(
//                                         color: Colors.grey[300],
//                                         blurRadius: 3,
//                                         spreadRadius: 1,
//                                         offset: Offset(1,2),
//                                         ),
//                                         ],
//                                         borderRadius: BorderRadius.circular(7),
//                                         ),
//                                        width: double.infinity,
//                                         child: Padding(
//                                           padding: const EdgeInsets.only(top: 50),
//                                             child: Column(
//                                              children: [
//                                                height(30),
//                                                 Text('كيف كانت خدمة المطعم ؟',style: TextStyle(
//                                                   fontSize: 18, fontWeight: FontWeight.bold),),
//                                                 height(30),
//                                                 Padding(
//                                                     padding: const EdgeInsets.only(left: 25,right: 25),
//                                                     child: Text('ستساعد ملاحظاتك في تحسين تجربة التسليم',
//                                                       style:TextStyle(
//                                                       height: 1.7,
//                                                       fontSize: 16,
//                                                       color: Colors.grey[500],
//                                                       fontWeight: FontWeight.normal
//                                                       ),
//                                                       textAlign: TextAlign.center,),
//                                                       ),
//                                             height(30),
//                                           Row(
//                                             crossAxisAlignment: CrossAxisAlignment.center,
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               children: [
//                                               TextButton(
//                                               onPressed: ()async{
//                                                 await http.post(
//                                                     Uri.parse('https://api.canariapp.com/v1/client/reviews'),
//                                                     headers:{'Content-Type':'application/json','Accept':'application/json',
//                                                       'Authorization': 'Bearer ${access_token}'},
//                                                     body: jsonEncode(
//                                                         {
//                                                           "order_id":"804",
//                                                           "rate":7,
//                                                           "description":null,
//                                                           "reviewedable":"store"
//                                                         }
//                                                     )
//                                                 );
//                                               Setstate(() {
//                                                 isRestaurantRateunLiked = true;
//                                               isRestaurantRate = true;
//                                                 isRestaurantRateLiked = false;
//                                               print(isRestaurantRateunLiked);
//                                               });
//                                               },
//                                               child: Container(
//                                               height: 80,
//                                               width: 80,
//                                               decoration: BoxDecoration(
//                                               border: Border.all(color: Colors.grey[300],width: 1),
//                                               shape: BoxShape.circle,
//                                               ),
//                                               child:Center(
//                                               child: FaIcon(
//                                                 isRestaurantRateunLiked ? FontAwesomeIcons.solidThumbsDown : FontAwesomeIcons.thumbsDown,
//                                               color: Colors.blue,
//                                               size: 30,
//                                               ),
//                                               ),
//                                               ),
//                                               ),
//                                               width(10),
//                                               TextButton(
//                                               onPressed: ()async{
//                                                 await http.post(
//                                                     Uri.parse('https://api.canariapp.com/v1/client/reviews'),
//                                                     headers:{'Content-Type':'application/json','Accept':'application/json',
//                                                       'Authorization': 'Bearer ${access_token}'},
//                                                     body: jsonEncode(
//                                                         {
//                                                           "order_id":"804",
//                                                           "rate":7,
//                                                           "description":null,
//                                                           "reviewedable":"store"
//                                                         }
//                                                     )
//                                                 ).then((value){
//                                                   print(value.body);
//                                                 });
//                                               Setstate(() {
//                                               isRestaurantRateLiked = true;
//                                               isRestaurantRateunLiked =false;
//                                               isRestaurantRate = true;
//                                               print(isRestaurantRateLiked);
//                                               });
//                                               },
//                                               child: Container(
//                                               height: 80,
//                                               width: 80,
//                                               decoration: BoxDecoration(
//                                               border: Border.all(color: Colors.grey[300],width: 1),
//                                               shape: BoxShape.circle,
//                                               ),
//                                               child:Center(
//                                               child: FaIcon(
//                                                 isRestaurantRateLiked ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
//                                               color: Colors.blue,
//                                               size: 30,
//                                               ),
//                                               ),
//                                               ),
//                                               ),
//                                               ],
//                                               )
//                                     ],
//                                        ),
//                                       ),
//                                      ),
//                                     ),),
//                             Align(
//                             alignment:AlignmentDirectional.topCenter,
//                               child: Container(
//                                 height: 100,
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.blue,
//                                 ),
//                           child:ClipRRect(
//                           borderRadius: BorderRadius.circular(50.0),
//                           child: Image.network('https://api.canariapp.com/media/301/LA-FAVORITA-(2).png',fit: BoxFit.cover,),
//                           )
//                           ),
//                           )
//                           ],
//                           ),
//                           ),
//                           )
//
//                       ],
//                     ):
//                    Column(
//                      children: [
//                        Container(
//                          height: 450,
//                          width: 370,
//                          color: Colors.transparent,
//                          child: Container(
//                            height:450,
//                            child: Stack(
//                              children: [
//                                Align(
//                                  alignment:AlignmentDirectional.bottomCenter,
//                                  child: Padding(
//                                    padding: const EdgeInsets.only(left: 25,right: 15,bottom: 20,top: 55),
//                                    child: Container(
//                                      height: 400,
//                                      decoration: BoxDecoration(
//                                        color:Colors.white,
//                                        boxShadow: [
//                                          BoxShadow(
//                                            color: Colors.grey[300],
//                                            blurRadius: 3,
//                                            spreadRadius: 1,
//                                            offset: Offset(1,2),
//                                          ),
//                                        ],
//                                        borderRadius: BorderRadius.circular(7),
//                                      ),
//                                      width: double.infinity,
//                                      child: Padding(
//                                        padding: const EdgeInsets.only(top: 50),
//                                        child: Column(
//                                          children: [
//                                            height(30),
//                                            Text('كيف كانت خدمة التوصيل ؟',style: TextStyle(
//                                                fontSize: 18, fontWeight: FontWeight.bold),),
//                                            height(30),
//                                            Padding(
//                                              padding: const EdgeInsets.only(left: 25,right: 25),
//                                              child: Text('ستساعد ملاحظاتك في تحسين تجربة التسليم',
//                                                style:TextStyle(
//                                                    height: 1.7,
//                                                    fontSize: 16,
//                                                    color: Colors.grey[500],
//                                                    fontWeight: FontWeight.normal
//                                                ),
//                                                textAlign: TextAlign.center,),
//                                            ),
//                                            height(30),
//                                            Row(
//                                              crossAxisAlignment: CrossAxisAlignment.center,
//                                              mainAxisAlignment: MainAxisAlignment.center,
//                                              children: [
//                                                TextButton(
//                                                  onPressed: ()async{
//                                                    await http.post(
//                                                        Uri.parse('https://api.canariapp.com/v1/client/reviews'),
//                                                        headers:{'Content-Type':'application/json','Accept':'application/json',
//                                                          'Authorization': 'Bearer ${access_token}'},
//                                                        body: jsonEncode(
//                                                            {
//                                                              "order_id":"804",
//                                                              "rate":7,
//                                                              "description":null,
//                                                              "reviewedable":"store"
//                                                            }
//                                                        )
//                                                    ).then((value) {
//                                                      print(value.body);
//                                                    });
//                                                    Setstate(() {
//                                                      isunLiked = true;
//                                                      isDrivedRate = true;
//
//                                                      print(isunLiked);
//                                                    });
//                                                  },
//                                                  child: Container(
//                                                    height: 80,
//                                                    width: 80,
//                                                    decoration: BoxDecoration(
//                                                      border: Border.all(color: Colors.grey[300],width: 1),
//                                                      shape: BoxShape.circle,
//                                                    ),
//                                                    child:Center(
//                                                      child: FaIcon(
//                                                        isunLiked ? FontAwesomeIcons.solidThumbsDown : FontAwesomeIcons.thumbsDown,
//                                                        color: Colors.blue,
//                                                        size: 30,
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ),
//                                                width(10),
//                                                TextButton(
//                                                  onPressed: ()async{
//                                                    await http.post(
//                                                        Uri.parse('https://api.canariapp.com/v1/client/reviews'),
//                                                        headers:{'Content-Type':'application/json','Accept':'application/json',
//                                                          'Authorization': 'Bearer ${access_token}'},
//                                                        body: jsonEncode(
//                                                            {
//                                                              "order_id":"804",
//                                                              "rate":7,
//                                                              "description":null,
//                                                              "reviewedable":"store"
//                                                            }
//                                                        )
//                                                    ).then((value) {
//                                                      print(value.body);
//                                                    });
//                                                    Setstate(() {
//                                                      isLiked = true;
//                                                      isDrivedRate = true;
//                                                      print(isLiked);
//                                                    });
//                                                  },
//                                                  child: Container(
//                                                    height: 80,
//                                                    width: 80,
//                                                    decoration: BoxDecoration(
//                                                      border: Border.all(color: Colors.grey[300],width: 1),
//                                                      shape: BoxShape.circle,
//                                                    ),
//                                                    child:Center(
//                                                      child: FaIcon(
//                                                        isLiked ? FontAwesomeIcons.solidThumbsUp : FontAwesomeIcons.thumbsUp,
//                                                        color: Colors.blue,
//                                                        size: 30,
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            )
//                                          ],
//                                        ),
//                                      ),
//                                    ),
//                                  ),),
//                                Align(
//                                  alignment:AlignmentDirectional.topCenter,
//                                  child: Container(
//                                      height: 100,
//                                      width: 100,
//                                      decoration: BoxDecoration(
//                                        shape: BoxShape.circle,
//                                        color: Colors.blue,
//                                      ),
//                                      child:ClipRRect(
//                                        borderRadius: BorderRadius.circular(50.0),
//                                        child: Image.asset('assets/rider.png',fit:BoxFit.cover),
//                                      )
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                        )
//
//                      ],
//                    )
//                   ],
//                 ):
//                 Column(children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Padding(
//                               padding: const EdgeInsets.only(right: 50,top: 5),
//                               child: Container(
//                                 height: 90,
//                                 width: 90,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     image: DecorationImage(image:AssetImage('assets/rider.png'),fit: BoxFit.cover)
//                                 ),
//                               )
//                           ),
//                           Padding(
//                               padding: const EdgeInsets.only(left: 20,top: 10),
//                               child: Container(
//                                 height: 90,
//                                 width: 90,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     image: DecorationImage(image:NetworkImage('https://api.canariapp.com/media/301/LA-FAVORITA-(2).png'))
//                                 ),
//                               )
//                           ),
//                         ],
//                       ),
//                       height(15),
//                       Text('قيم الخدمتنا رأيك يهمنا'),
//                       height(10),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20,right: 20),
//                         child: Text('أخبرنا عن جودة الطعام المطعم والخدمة التوصيل لي تساعدنا على تحسين من الخدمة',style:TextStyle(
//                             height: 1.5
//                         ),textAlign: TextAlign.center,),
//                       ),
//                       height(20),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 35,right: 35,top: 15),
//                         child: GestureDetector(
//                           onTap:(){
//                             Setstate((){
//                               isNext = true;
//
//                             });
//                           },
//                           child: Container(
//                             height: 55,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.circular(5)
//                             ),
//                             child:Center(
//                               child:Text('استمر',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
//                             ),
//                           ),
//                         ),
//                       ),
//                       height(10),
//                       GestureDetector(
//                         onTap:(){
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           height: 55,
//                           width: double.infinity,
//                           color: Colors.transparent,
//                           child:Center(
//                             child:Text('ليس الآن',style: TextStyle(color: AppColor,fontWeight: FontWeight.bold),),
//                           ),
//                         ),
//                       ),
//                       height(15)
//                     ],)
//                 ],
//               );
//             },
//
//           );
//         });
//
//
// }, child:Text('open')),


//









//