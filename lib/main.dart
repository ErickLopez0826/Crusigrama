import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/main_menu_widget.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Crucigrama',
        debugShowCheckedModeBanner: false,
        theme: _buildDarkMinimalistTheme(),
        home: MainMenuWidget(),
      ),
    ),
  );
}

ThemeData _buildDarkMinimalistTheme() {
  const darkBackground = Color(0xFF0A0A0A);
  const darkSurface = Color(0xFF151515);
  const darkCard = Color(0xFF1E1E1E);
  const accentPrimary = Color(0xFFFF3B3B);
  const accentSecondary = Color(0xFFFF6B6B);
  const textPrimary = Color(0xFFE5E5E5);
  const textSecondary = Color(0xFF9E9E9E);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    
    colorScheme: ColorScheme.dark(
      // Fondos
      surface: darkSurface,
      primary: accentPrimary,
      secondary: accentSecondary,
      tertiary: Color(0xFFFF5252),
      error: Color(0xFFFF5252),
      
      // Contenedores
      primaryContainer: darkCard,
      secondaryContainer: Color(0xFF252525),
      tertiaryContainer: Color(0xFF2A2A2A),
      
      // Textos
      onPrimary: darkBackground,
      onSurface: textPrimary,
      onPrimaryContainer: textSecondary,
      onSecondary: darkBackground,
      
      // Otros
      outline: Color(0xFF2A2A2A),
    ),
    
    // AppBar minimalista
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: accentPrimary),
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
      ),
    ),
    
    // Cards oscuras
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    
    // Botones minimalistas
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentPrimary,
        foregroundColor: darkBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
        ),
      ),
    ),
    
    // Texto general
    textTheme: TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w300),
      displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w300),
      headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w300),
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: textSecondary, fontWeight: FontWeight.w400),
      labelSmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w400),
    ),
    
    // Dividers sutiles
    dividerTheme: DividerThemeData(
      color: Color(0xFF2A2A2A),
      thickness: 1,
      space: 1,
    ),
    
    // Progress indicators
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: accentPrimary,
    ),
    
    // Menu
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(darkCard),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}
