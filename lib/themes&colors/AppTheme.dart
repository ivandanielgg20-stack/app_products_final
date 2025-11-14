import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const colorSeed = Color.fromARGB(235, 214, 5, 5);
const scaffoldBackgroundColor= Color(0xFfF8F7F7);
class AppTheme {
  ThemeData getTheme()=> ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colorSeed,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserratAlternates().copyWith(fontSize: 40,fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.montserratAlternates().copyWith(fontSize: 30, fontWeight: FontWeight.bold),
        titleSmall: GoogleFonts.montserratAlternates().copyWith(fontSize: 20),



      ),
      scaffoldBackgroundColor: const Color.fromARGB(169, 68, 49, 68),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(
            GoogleFonts.montserratAlternates()
            .copyWith(fontWeight: FontWeight.w600)

          )
        )
      ),
      appBarTheme: AppBarTheme(
        backgroundColor : const Color.fromARGB(255, 255, 255, 255),
        titleTextStyle: GoogleFonts.montserratAlternates().copyWith(fontSize: 25,fontWeight:  FontWeight.bold, color: Colors.black),
      )

    );

  

}


