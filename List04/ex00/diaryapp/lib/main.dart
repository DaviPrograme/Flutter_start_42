import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    home: Scaffold(
      body: Container(
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/loginImage02.jpg"), fit: BoxFit.cover)),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 203, 240, 240),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text("Dear Diary", 
                  style: GoogleFonts.satisfy(
                    fontSize: 40,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Access with:", style: TextStyle(fontSize: 20),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          print("teste1");
                        },
                        child: Image.asset("assets/logoGoogle.png"),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: 70,
                      child: GestureDetector(
                        onTap: () {
                          print("teste2");
                        },
                        child: Image.asset("assets/logoGithub.png"),
                      ),
                    ),
                  ],
                )
              ],
            ) 
          ),
        ) 
      ),
    )
   );
  }
}



