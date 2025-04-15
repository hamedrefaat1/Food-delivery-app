import 'package:ecomarce/pages/signup.dart';
import 'package:ecomarce/widgets/content_onboard_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;
  late PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
      children: [
        Expanded(
          flex: 3,
          child: PageView.builder(
              controller: controller,
              itemCount: contentsForPages.length,
              onPageChanged: (index) {
               setState(() {
                  currentIndex = index;
               });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        contentsForPages[i].image,
                        width: 300,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        contentsForPages[i].title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                       const SizedBox(height: 10),
                        Text(
                          contentsForPages[i].descreaption,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                );
              }
              ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(contentsForPages.length, (index){
               return bulidDot(index);
          }),
        ),
        SizedBox(height: 40,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton(
            onPressed: (){
              if(currentIndex == contentsForPages.length -1){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
              }else{
                controller.nextPage(
                   duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                   );
              }
            }, 
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xFFe74b1a),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
             child: Text(
                currentIndex == contentsForPages.length - 1 ? "START" : "NEXT",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            )
          
          ),
          SizedBox(height: 60,)
      ],
    ));
  }
  
  Widget bulidDot(int index) {
    return Container(
      height: 10,
      width: currentIndex== index?20 :10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: currentIndex== index? Color(0xFFe74b1a): Colors.grey,
        borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}
