import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({Key key}) : super(key: key);

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () {
                  // Handle share action
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  // Handle edit action
                  Navigator.pop(context);
                },
              ),
              // Add more list tiles or widgets as needed
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          _showBottomSheet(context);
        }, icon:Icon(Icons.close,color: Colors.black,)),
      ),
      body:Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).size.height * 0.3,
            child:Image.asset(
              "assets/play.jpg",
              fit:BoxFit.cover,
            ),
          ),
          Positioned(child: DraggableScrollableSheet(
              initialChildSize: .4,
              minChildSize: .4,
              maxChildSize: .9,
           builder: (BuildContext context, ScrollController scrollController) {
            return Container(
             width: double.infinity,
            color: Colors.red,
              child: ListView(
                physics: BouncingScrollPhysics(),
                controller: scrollController,
                children: [

                ],
              ),
            );
           }))
        ],
      )
    );
  }
}
