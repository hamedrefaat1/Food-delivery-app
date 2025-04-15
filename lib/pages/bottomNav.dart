import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ecomarce/pages/home.dart';
import 'package:ecomarce/pages/order.dart';
import 'package:ecomarce/pages/profile.dart';
import 'package:ecomarce/pages/wallet.dart';
import 'package:flutter/material.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTapIndex=0;
  List<Widget> pages=const [Home(),OrderScreen(), WalletScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        animationDuration:const  Duration(milliseconds: 500),
        color: Colors.black,
        backgroundColor: Colors.white,
        onTap: (index){
              setState(() {
                currentTapIndex=index;
              });
        },
        items: const [
          Icon(Icons.home_outlined , color:Colors.white,),
           Icon(Icons.shopping_bag_outlined , color:Colors.white,),
            Icon(Icons.wallet_outlined, color:Colors.white,),
             Icon(Icons.person_outline , color:Colors.white,),
        ]
        
        ),
        body: pages[currentTapIndex],
    );
  }
}