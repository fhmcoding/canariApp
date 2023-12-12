import 'dart:async';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shopapp/Layout/HomeLayout/layoutPage.dart';
import 'package:shopapp/modules/pages/coupons.dart';
import 'package:shopapp/modules/pages/privacy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Layout/shopcubit/shopstate.dart';
import 'package:shopapp/modules/Register/register.dart';
import 'package:shopapp/modules/pages/myorders.dart';
import 'package:shopapp/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../class/langauge.dart';
import '../../localization/demo_localization.dart';
import '../../localization/localization_constants.dart';
import '../../main.dart';
import '../../modules/pages/share.dart';
import '../../modules/pages/support_service.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/remote/cachehelper.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../shopcubit/shopcubit.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;

bool isloading = true;
String phoneNumber;
String phoneCode = '+212';
bool onEditing = true;


final GlobalKey<FormState> otpkey = GlobalKey<FormState>();
final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String selectelang;
  String language = Cachehelper.getData(key:"langugeCode");
  void _changeLanguge(Language lang) async{
    Locale _temp = await setLocale(lang.languageCode);
    MyApp.setLocale(context, _temp);
    setState(() {

      lg = lang.languageCode;
      Cachehelper.sharedPreferences.setString("langugeCode",lang.languageCode);
      print('lang is :${lg}');
    });
  }
  var fbm = FirebaseMessaging.instance;
  String code;
  String fcmtoken='';
  final GlobalKey<FormState> fromkey = GlobalKey<FormState>();
  var FirstnameController = TextEditingController();
  var InvitationCodeController = TextEditingController();
  var LastnameController = TextEditingController();
  var PhoneController = TextEditingController();
  var otpController = TextEditingController();
  bool islogin = false;
  bool isupdate = false;
  bool iswebview = false;
  bool isProfileUpdate = true;
  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer timer;
  bool isLoading=true;
  bool isRegisterLoading=true;
  String phoneNumber, verificationId;
  String otp, authStatus = "";
  void start(){
    timer = Timer.periodic(Duration(milliseconds:70), (_){
      if(seconds>0){
        seconds--;
        setState(() {
        });
      }
  });
  }
  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
          print('${authStatus}');

        });
      },
      verificationFailed: (authException) {
        setState(() {
          authStatus = authException.message;
          print(authStatus);
          Fluttertoast.showToast(
              msg: "فشلت محاولة حصول على كود يرجى تواصل معنا",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              webShowClose:false,
              backgroundColor:AppColor,
              textColor: Colors.white,
              fontSize: 16.0
          );

          print('${authStatus}');
        });
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
          print('${authStatus}');
        });

      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }
  @override
  void initState() {
    selectelang = language=="ar"? 'تغيير لغة':"Changer de langue";
    super.initState();
  }

  

  

  @override
  Widget build(BuildContext context) {
    String firstname = Cachehelper.getData(key: "first_name");
    String lastname = Cachehelper.getData(key: "last_name");
    String phone = Cachehelper.getData(key: "phone");

    return BlocProvider(
      create: (context)=>ShopCubit()..GetProfile(),
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){
        },
        builder: (context,state){
          FirstnameController.text = firstname;
          LastnameController.text = lastname;

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              toolbarHeight: 20,
            ),
            backgroundColor: Colors.white,

            body: firstname != null && isupdate==false?
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:0,bottom:0,right:0),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Container(
                               height:50,
                               width:50,
                               decoration:BoxDecoration(
                                 shape: BoxShape.circle,
                                 color:Color(0xfff6cfd2),
                                 border: Border.all(
                                   width:1.2,
                                   color:Colors.white,
                                 ),
                               ),
                               child:Center(child: Text('${firstname[0].toUpperCase()}${lastname[0].toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color:AppColor),)),
                             ),
                             width(10),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Text('${firstname} ${lastname}',style: TextStyle(fontSize: 16,color: Colors.black)),
                                 Text('${phone}',style: TextStyle(fontSize: 10,color: Colors.grey),textDirection:TextDirection.ltr),
                               ],
                             ),
                           ],
                         ),
                         Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 10,right: 20),
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isupdate = true;
                                });
                              },
                              child: Container(
                                height: 20,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Icon(Icons.edit,size: 18),
                                    width(10),
                                    Text(DemoLocalization.of(context).getTranslatedValue('Modifier_le_compte'),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(20),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10),
                      child: GestureDetector(
                        onTap: (){
                          navigateTo(context, Myorder());
                        },
                        child: Container(
                          height: 20,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.fastfood),
                              width(10),
                              Text(DemoLocalization.of(context).getTranslatedValue('Mes_demandes'),style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                    CouponActive?Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10),
                      child: GestureDetector(
                        onTap: (){
                          navigateTo(context, Couponds());
                        },
                        child: Row(
                          children: [
                            Icon(Icons.turned_in_not_sharp),
                            width(10),
                            Text(DemoLocalization.of(context).getTranslatedValue('Mes_Coupons'),style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ):height(0),
                    shareActive?Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10),
                      child: GestureDetector(
                        onTap: (){
                          navigateTo(context, Share());
                        },
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            width(10),
                            Text(DemoLocalization.of(context).getTranslatedValue('Partagez_et_gagnez'),style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ):height(0),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10),
                      child: GestureDetector(
                        onTap: (){
                          navigateTo(context, SupportService());
                        },
                        child: Container(
                          height: 20,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.whatsapp),
                              width(10),
                              Text(DemoLocalization.of(context).getTranslatedValue('Contactez_nous'),style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10),
                      child: GestureDetector(
                        onTap: (){
                          navigateTo(context, Privacy());
                        },
                        child: Row(
                          children: [
                            Icon(Icons.privacy_tip_outlined),
                            width(10),
                            Text(DemoLocalization.of(context).getTranslatedValue('Confidentiality'),style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,bottom: 10,right: 10),
                      child: GestureDetector(
                        onTap: (){
                        Cachehelper.removeData(key: 'token');
                        Cachehelper.removeData(key: 'first_name');
                        Cachehelper.removeData(key: 'last_name');
                        Cachehelper.removeData(key: 'phone');
                        Cachehelper.removeData(key: 'deviceId');
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                          latitude: latitude,
                          longitude: longitude,
                          myLocation: myLocation,

                        )), (route) => false);
                        },
                        child: Container(
                          height: 20,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              width(10),
                              Text(DemoLocalization.of(context).getTranslatedValue('Déconnexion'),style: TextStyle(fontWeight: FontWeight.bold),)
                            ],
                          ),
                          width: double.infinity,
                        ),
                      ),
                    ),
                    height(20),
                    Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color:Colors.grey[300],width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:Padding(
                          padding:
                          const EdgeInsets.only(left: 5, top: 0, right: 5),
                          child: DropdownButton(
                            onChanged: (language) async {
                              await _changeLanguge(language);
                              setState(() {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LayoutPage()),
                                        (route) => false);
                              });
                            },

                            icon:Padding(
                              padding:
                              const EdgeInsets.only(top: 0, right: 0, left: 0),
                              child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color:AppColor
                              ),
                            ),
                            underline: SizedBox(),
                            isExpanded: true,
                            hint:Row(
                              children:[
                                width(5),
                                Icon(
                                  Icons.language,
                                  color:Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 30,
                                  width: 2,
                                  color:Colors.grey[300],
                                ),
                                width(10),
                                Text(
                                  "${selectelang}",
                                  style: TextStyle(color: Colors.red,fontSize: 13.5),
                                ),
                              ],
                            ),
                            items: Language.languageList()
                                .map<DropdownMenuItem<Language>>((lang){
                                  print(lang);
                              return DropdownMenuItem(
                                value:lang,child:Text(lang.name),
                              );
                            }
                            ).toList(),
                          ),
                        )),
                  ],
                ),
              ),
            ):
            iswebview == false ?
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/CANARY-.png',)),
                  height(50),
                  Form(
                    key: fromkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(isupdate==false?'اهلا بك في كناري':'تعديل الحساب',style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Hind"
                              ),),
                            ),
                            height(20),
                            islogin==false?Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: buildTextFiled(
                                Validat: (value) {
                                  RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]');
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم الأول لا يجب أن تكون فارغة ';
                                  }
                                  if(arabicRegex.hasMatch(value)){
                                    return 'الرجاء إدخال الاسم الأول بالفرنسية';
                                  }
                                  return null;
                                },
                                onEditingComplete: (){
                                  if (fromkey.currentState.validate()) {
                                    fromkey.currentState.save();
                                  }
                                },
                                controller: FirstnameController,
                                keyboardType: TextInputType.name,
                                hintText: 'الاسم الأول',
                                valid: 'الاسم الأول',
                              ),
                            ):height(0),
                            islogin==false? height(25):height(0),
                            islogin==false? Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: buildTextFiled(
                                Validat: (value) {
                                  RegExp arabicRegex = RegExp(r'[\u0600-\u06FF]');
                                  if (value == null || value.isEmpty) {
                                    return 'اسم العائلة لا يجب أن تكون فارغة ';
                                  }
                                  if(arabicRegex.hasMatch(value)){
                                    return 'الرجاء إدخال اسم العائلة بالفرنسية';
                                  }
                                  return null;
                                },
                                onEditingComplete: (){
                                  if (fromkey.currentState.validate()) {
                                    fromkey.currentState.save();
                                  }
                                },
                                controller: LastnameController,
                                valid: 'اسم العائلة',
                                keyboardType: TextInputType.name,
                                hintText: 'اسم العائلة',
                              ),
                            ):height(0),
                            height(25),
                            isupdate==false?
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 57,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(4),
                                          border: Border.all(
                                              color: Colors.grey[300],
                                              width: 1.5)),
                                      child: CountryListPick(
                                          theme: CountryTheme(
                                            initialSelection:
                                            'Choisir un pays',
                                            labelColor: AppColor,
                                            alphabetTextColor:
                                            AppColor,
                                            alphabetSelectedTextColor:
                                            Colors.red,
                                            alphabetSelectedBackgroundColor:
                                            Colors.grey[300],
                                            isShowFlag: false,
                                            isShowTitle: false,
                                            isShowCode: true,
                                            isDownIcon: false,
                                            showEnglishName: true,
                                          ),
                                          appBar: AppBar(
                                            backgroundColor:
                                            AppColor,
                                            title:
                                            Text('Choisir un pays',
                                              style: TextStyle(color: Colors.white),),
                                          ),
                                          initialSelection: '+212',
                                          onChanged: (CountryCode code) {
                                            print(code.name);
                                            print(code.dialCode);
                                            phoneCode = code.dialCode;
                                          },
                                          useUiOverlay: false,
                                          useSafeArea: false),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    flex: 3,
                                    child: buildTextFiled(
                                        Validat: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'رقم الهاتف لا يجب أن تكون فارغة ';
                                          }
                                          return null;
                                        },
                                        onEditingComplete: (){
                                          if (fromkey.currentState.validate()) {
                                            fromkey.currentState.save();
                                          }
                                        },
                                      controller: PhoneController,
                                        keyboardType: TextInputType.number,
                                        hintText: 'رقم الهاتف',
                                        valid: 'رقم الهاتف',
                                        onSaved: (number) {
                                          if (number.length == 9) {
                                            phoneNumber = "${phoneCode}${number}";
                                          } else {
                                            final replaced = number.replaceFirst(RegExp('0'), '');
                                            phoneNumber = "${phoneCode}${replaced}";
                                          }
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            ):height(0),
                            islogin==false?height(25):height(0),
                            islogin==false?
                            isupdate==false?Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 20, right: 20),
                                 child: buildTextFiled(
                                   suffixIcon:state is ValidateInvitationLoadingState?CircleAvatar(
                                       backgroundColor: Colors.transparent,
                                       maxRadius: 1,
                                       child: Padding(
                                         padding: const EdgeInsets.only(left: 5),
                                         child: CircularProgressIndicator(color: Colors.blue,),
                                       )):ValideIcon(ShopCubit.get(context).isValid),
                                   inputFormatters:[
                                     new LengthLimitingTextInputFormatter(6),
                                   ],
                                   onchange: (value)async{
                                     if(value.length==6){
                                       ShopCubit.get(context).ValidateInvitation(value);
                                     }else{
                                       ShopCubit.get(context).isValid = null;
                                       setState(() {

                                       });
                                     }
                                   },
                                   controller: InvitationCodeController,
                                   keyboardType: TextInputType.name,
                                   hintText: 'كود دعوة  (اختياري)',
                                 ),

                               ),
                               islogin==false? height(15):height(0),
                               ShopCubit.get(context).isValid == null?height(0):Padding(
                                 padding: const EdgeInsets.only(left: 20, right: 20),
                                 child: ShopCubit.get(context).isValid==false?Text('كود دعوة غير صحيح',style: TextStyle(
                                   color: AppColor,
                                   fontSize: 12.5,
                                 ),):height(0),
                               )
                             ],
                           ):height(0):height(0),

                            height(0),
                            isupdate==false?height(25):height(0),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: GestureDetector(
                                onTap: (){
                                if (fromkey.currentState.validate()) {
                                    fromkey.currentState.save();
                                    if(isupdate){
                                     isProfileUpdate = false;
                                      ShopCubit.get(context).UpdateProfile({
                                        "first_name":FirstnameController.text,
                                        "last_name":LastnameController.text,
                                      }).then((value){
                                        setState(() {
                                          isProfileUpdate = true;
                                        });
                                        isupdate = false;
                                        isLoading = false;
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                          latitude: latitude,
                                          longitude: longitude,
                                          myLocation: myLocation,
                                        )), (route) => false);
                                      });
                                    }else{
                                      if(islogin==false){
                                        if(isOtpActive){
                                          verifyPhoneNumber(context);
                                          iswebview =true;
                                        }else{
                                            setState((){
                                              isRegisterLoading = false;
                                            });
                                          fbm.getToken().then((token)async{
                                            fcmtoken = token;
                                            await DioHelper.postData(
                                              data:{
                                                "first_name":FirstnameController.text,
                                                "last_name":LastnameController.text,
                                                "phone":"${phoneNumber}",
                                                "invitation_code":InvitationCodeController.text,
                                                "device":{
                                                  "token_firebase":"${fcmtoken}",
                                                  "device_id":"z0f33s43p4",
                                                  "device_name":"iphone",
                                                  "ip_address":"192.168.1.1",
                                                  "mac_address":"192.168.1.1"
                                                }
                                              },
                                              url: 'https://www.api.canariapp.com/v1/client/register',
                                            ).then((value) {
                                              Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                              Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                              Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                              Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                              Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                              setState(() {
                                                isRegisterLoading = true;
                                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  myLocation: myLocation,
                                                )),(route) => false);
                                              });
                                            }).catchError((error){
                                              setState(() {
                                                Fluttertoast.showToast(
                                                    msg: "ليس لديك حساب قم بانشاء واحد",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    webShowClose:false,
                                                    backgroundColor: AppColor,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0
                                                );
                                                isLoading = true;
                                                isRegisterLoading = true;
                                                islogin = false;
                                              });
                                            });
                                          });
                                        }
                                      }
                                      else{
                                        verifyPhoneNumber(context);
                                        iswebview =true;
                                      }
                                    }
                                    setState(() {

                                    });
                                }

                                  },
                                child:Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:AppColor
                                  ),
                                  child:isRegisterLoading?isProfileUpdate?Center(
                                      child: isloading ? Text(isupdate==false?'التالي':'تعديل',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ) : CircularProgressIndicator(color: Colors.white)):Center(child: CircularProgressIndicator(color: Colors.white)):Center(child: CircularProgressIndicator(color: Colors.white)),
                                  height: 58,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        ),
                        height(10),
                        isupdate==false?Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            islogin==false? Text('لدي حساب !'):Text('ليس لدي حساب !'),
                            islogin==false? TextButton(onPressed:(){
                              setState(() {
                                islogin = true;
                              });
                            },
                            child:Text('تسجيل الدخول', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16),)):
                            TextButton(onPressed:(){
                              setState(() {
                                islogin = false;
                              });
                            },
                                child: Text('إنشاء حساب', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16),))
                          ],
                        ):height(0),
                      ],
                    ),
                  ),
                ],
              ),
            ):Stack(
              children:<Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'تَحَقّق',
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    height(6),
                    Text('انتضر قليلا ثم أدخل الرمز الذي أرسلناه لك للتو على رقمك', style: TextStyle(fontSize: 17.0,color: Colors.grey[500]),textAlign: TextAlign.center),
                    TextButton(onPressed: (){
                      iswebview = false;
                      setState(() {

                      });
                    }, child: Text('تغيير رقم',
                      style: TextStyle(
                      color: AppColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.8
                    ),)),
                    VerificationCode(
                      fillColor: Colors.grey[100],
                      fullBorder:true,
                      underlineUnfocusedColor: Colors.grey[100],
                      textStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.number,
                      underlineColor: AppColor,
                      length: 6,
                      cursorColor: AppColor,
                      margin: const EdgeInsets.all(5),
                      onCompleted: (String value)async{
                        code = value;
                        isLoading = false;
                        await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code)).then((value){
                          if(islogin){
                            if(FirebaseAuth.instance.currentUser!=null){
                              fbm.getToken().then((token)async{
                                fcmtoken = token;
                                await DioHelper.postData(
                                  data:{
                                    "phone": "${phoneNumber}",
                                    "uid": "${FirebaseAuth.instance.currentUser.uid}",
                                    "device":{
                                      "token_firebase":"${fcmtoken}",
                                      "device_id":"z0f33s43p4",
                                      "device_name":"iphone",
                                      "ip_address":"192.168.1.1",
                                      "mac_address":"192.168.1.1"
                                    }
                                  },
                                  url: 'https://www.api.canariapp.com/v1/client/login',
                                ).then((value) {
                                  print('======================================================================');
                                  printFullText(value.data.toString());
                                  print('======================================================================');
                                  Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                  Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                  Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                  Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                  Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                  setState(() {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                      latitude: latitude,
                                      longitude: longitude,
                                      myLocation: myLocation,
                                    )), (route) => false);
                                  });
                                }).catchError((error){
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "ليس لديك حساب قم بانشاء واحد",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        webShowClose:false,
                                        backgroundColor: AppColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    isLoading =true;
                                    islogin = false;
                                    iswebview = false;
                                  });
                                });
                              });
                            }
                          }

                          else{
                            fbm.getToken().then((token)async{
                              fcmtoken = token;
                              await DioHelper.postData(
                                data:{
                                  "first_name":FirstnameController.text,
                                  "last_name":LastnameController.text,
                                  "phone":"${phoneNumber}",
                                  "invitation_code":InvitationCodeController.text,
                                  "device":{
                                    "token_firebase":"${fcmtoken}",
                                    "device_id":"z0f33s43p4",
                                    "device_name":"iphone",
                                    "ip_address":"192.168.1.1",
                                    "mac_address":"192.168.1.1"
                                  }
                                },
                                url: 'https://www.api.canariapp.com/v1/client/register',
                              ).then((value) {
                                Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                setState(() {
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                    latitude: latitude,
                                    longitude: longitude,
                                    myLocation: myLocation,
                                  )), (route) => false);
                                });
                              }).catchError((error){
                                setState(() {
                                  Fluttertoast.showToast(
                                      msg: "لديك حساب قم بتسجيل دخول",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      webShowClose:false,
                                      backgroundColor: AppColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  isLoading = true;
                                  islogin = true;
                                  iswebview = false;
                                });
                              });
                            });
                          }

                        }).catchError((e){
                          print(e.toString());
                        });
                        setState(()  {


                        });
                      },
                      onEditing: (bool value) {
                        setState(() {
                          onEditing = value;
                        });
                        if (!onEditing) FocusScope.of(context).unfocus();
                      },
                    ),


                   height(10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('لم تتلق رمز؟ '),
                        TextButton(onPressed: (){
                          verifyPhoneNumber(context);
                        }, child: Text('إعادة إرسال',style: TextStyle(
                            color: AppColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.8
                        ),)),
                      ],
                    ),

                    height(6),
                    GestureDetector(
                      onTap: ()async{
                        isLoading = false;
                        await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code)).then((value){
                          print('sign in successfully');
                          if(islogin){
                            if(FirebaseAuth.instance.currentUser!=null){
                              fbm.getToken().then((token)async{
                                fcmtoken = token;
                                await DioHelper.postData(
                                  data:{
                                    "phone": "${phoneNumber}",
                                    "uid": "${FirebaseAuth.instance.currentUser.uid}",
                                    "device":{
                                      "token_firebase":"${fcmtoken}",
                                      "device_id":"z0f33s43p4",
                                      "device_name":"iphone",
                                      "ip_address":"192.168.1.1",
                                      "mac_address":"192.168.1.1"
                                    }
                                  },
                                  url: 'https://www.api.canariapp.com/v1/client/login',
                                ).then((value) {
                                  printFullText(value.data.toString());
                                  Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                  Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                  Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                  Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                  Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                  setState(() {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                      latitude: latitude,
                                      longitude: longitude,
                                      myLocation: myLocation,
                                    )), (route) => false);
                                  });
                                }).catchError((error){
                                  setState(() {
                                    Fluttertoast.showToast(
                                        msg: "ليس لديك حساب قم بانشاء واحد",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        webShowClose:false,
                                        backgroundColor: AppColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                    isLoading =true;
                                    islogin = false;
                                    iswebview = false;
                                  });
                                });
                              });
                            }
                          }else{
                            fbm.getToken().then((token)async{
                              fcmtoken = token;
                              await DioHelper.postData(
                                data:{
                                  "first_name":FirstnameController.text,
                                  "last_name":LastnameController.text,
                                  "phone":"${phoneNumber}",
                                  "invitation_code":InvitationCodeController.text,
                                  "device":{
                                    "token_firebase":"${fcmtoken}",
                                    "device_id":"z0f33s43p4",
                                    "device_name":"iphone",
                                    "ip_address":"192.168.1.1",
                                    "mac_address":"192.168.1.1"
                                  }
                                },
                                url: 'https://www.api.canariapp.com/v1/client/register',
                              ).then((value) {
                                Cachehelper.sharedPreferences.setString("deviceId",value.data['device_id'].toString());
                                Cachehelper.sharedPreferences.setString("token",value.data['token']);
                                Cachehelper.sharedPreferences.setString("first_name",value.data['client']['first_name']);
                                Cachehelper.sharedPreferences.setString("last_name",value.data['client']['last_name']);
                                Cachehelper.sharedPreferences.setString("phone",value.data['client']['phone']);
                                setState(() {
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MyHomePage(
                                    latitude: latitude,
                                    longitude: longitude,
                                    myLocation: myLocation,
                                  )), (route) => false);
                                });
                              }).catchError((error){
                                setState(() {
                                  Fluttertoast.showToast(
                                      msg: "ليس لديك حساب قم بانشاء واحد",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      webShowClose:false,
                                      backgroundColor: AppColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                  isLoading =true;
                                  islogin = false;
                                  iswebview = false;
                                });
                              });
                            });
                          }

                        });

                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color:code!=null?AppColor:Colors.grey[300]
                          ),
                          child: Center(
                              child: isLoading ? Text(isupdate==false?'تاكيد':'تعديل',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ) : CircularProgressIndicator(color: Colors.white)),
                          height: 58,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    height(20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () async => await launch(
                                "https://wa.me/+212619157091?text= مشكلتي : لم يصلني كود"),
                            child: Text('تواصل معنا',style: TextStyle(
                                color: AppColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.8
                            ),)),
                        Text('اذا واجهت اي مشكلة في تسجيل'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
