import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the AR-enabled mobile application.
/// Implements Immersive Minimalism design with Adaptive Dark Foundation color scheme.
class AppTheme {
  AppTheme._();

  // AR-optimized color palette for camera-first interfaces
  static const Color primaryDark = Color(0xFF1A1A1A); // Deep charcoal background
  static const Color surfaceElevated = Color(0xFF2D2D2D); // Elevated surface color
  static const Color accentCyan = Color(0xFF00D4FF); // Bright cyan for interactive elements
  static const Color successGreen = Color(0xFF00FF88); // Vibrant green for detection confirmation
  static const Color warningAmber = Color(0xFFFFB800); // Amber for permission requests
  static const Color errorCoral = Color(0xFFFF4757); // Coral red for errors
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure white text
  static const Color textSecondary = Color(0xFFB0B0B0); // Light gray secondary text
  static const Color surfaceNearBlack = Color(0xFF0F0F0F); // Near-black for cards
  static const Color overlayTransparent = Color(0xCC000000); // Semi-transparent overlay

  // Additional theme colors for comprehensive theming
  static const Color dividerColor = Color(0xFF2D2D2D);
  static const Color shadowColor = Color(0x33000000);
  static const Color focusColor = Color(0x1F00D4FF);
  static const Color hoverColor = Color(0x0F00D4FF);
  static const Color splashColor = Color(0x1F00D4FF);
  static const Color highlightColor = Color(0x1F00D4FF);

  /// Dark theme optimized for AR visibility and camera interfaces
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accentCyan,
      onPrimary: primaryDark,
      primaryContainer: accentCyan.withAlpha(51),
      onPrimaryContainer: textPrimary,
      secondary: successGreen,
      onSecondary: primaryDark,
      secondaryContainer: successGreen.withAlpha(51),
      onSecondaryContainer: textPrimary,
      tertiary: warningAmber,
      onTertiary: primaryDark,
      tertiaryContainer: warningAmber.withAlpha(51),
      onTertiaryContainer: textPrimary,
      error: errorCoral,
      onError: textPrimary,
      errorContainer: errorCoral.withAlpha(51),
      onErrorContainer: textPrimary,
      surface: primaryDark,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: dividerColor,
      outlineVariant: dividerColor.withAlpha(128),
      shadow: shadowColor,
      scrim: overlayTransparent,
      inverseSurface: textPrimary,
      onInverseSurface: primaryDark,
      inversePrimary: accentCyan,
      surfaceTint: accentCyan,
    ),
    scaffoldBackgroundColor: primaryDark,
    cardColor: surfaceNearBlack,
    dividerColor: dividerColor,
    focusColor: focusColor,
    hoverColor: hoverColor,
    splashColor: splashColor,
    highlightColor: highlightColor,
    
    // AppBar theme for contextual control emergence
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme for elevated components with subtle layering
    cardTheme: CardThemeData(
      color: surfaceNearBlack,
      elevation: 4,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation optimized for gesture-first navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceElevated,
      selectedItemColor: accentCyan,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    // Floating action button for AR interactions
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentCyan,
      foregroundColor: primaryDark,
      elevation: 4,
      focusElevation: 6,
      hoverElevation: 6,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes for AR interface controls
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryDark,
        backgroundColor: accentCyan,
        disabledForegroundColor: textSecondary,
        disabledBackgroundColor: surfaceElevated,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentCyan,
        disabledForegroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: accentCyan, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentCyan,
        disabledForegroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography optimized for AR interfaces
    textTheme: _buildTextTheme(),

    // Input decoration for avatar customization forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceNearBlack,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: dividerColor.withAlpha(128)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: dividerColor.withAlpha(128)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accentCyan, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorCoral),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: errorCoral, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary.withAlpha(179),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Interactive element themes
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentCyan;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentCyan.withAlpha(77);
        }
        return dividerColor;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentCyan;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryDark),
      side: const BorderSide(color: textSecondary, width: 2),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentCyan;
        }
        return textSecondary;
      }),
    ),

    // Progress indicators for AR processing
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accentCyan,
      linearTrackColor: dividerColor,
      circularTrackColor: dividerColor,
    ),

    // Slider theme for avatar customization
    sliderTheme: SliderThemeData(
      activeTrackColor: accentCyan,
      thumbColor: accentCyan,
      overlayColor: accentCyan.withAlpha(51),
      inactiveTrackColor: dividerColor,
      valueIndicatorColor: accentCyan,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: primaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme for video navigation
    tabBarTheme: const TabBarThemeData(
      labelColor: accentCyan,
      unselectedLabelColor: textSecondary,
      indicatorColor: accentCyan,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip theme for contextual help
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Snackbar theme for feedback
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceElevated,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentCyan,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 6,
    ),

    // Bottom sheet theme for avatar customization
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceElevated,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
    ),

    // Dialog theme for permissions and settings
    dialogTheme: DialogThemeData(
      backgroundColor: surfaceElevated,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // List tile theme for settings
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: accentCyan.withAlpha(26),
      iconColor: textSecondary,
      textColor: textPrimary,
      selectedColor: accentCyan,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      subtitleTextStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // Chip theme for tags and filters
    chipTheme: ChipThemeData(
      backgroundColor: surfaceNearBlack,
      selectedColor: accentCyan.withAlpha(51),
      disabledColor: dividerColor,
      deleteIconColor: textSecondary,
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
  );

  /// Light theme (minimal implementation for system compatibility)
  static ThemeData lightTheme = darkTheme.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  );

  /// Helper method to build Inter-based text theme optimized for AR interfaces
  static TextTheme _buildTextTheme() {
    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for component headers
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for main content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Data text style using JetBrains Mono for technical information
  static TextStyle dataTextStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? textSecondary,
      letterSpacing: 0,
      height: 1.33,
    );
  }

  /// Animation durations for consistent motion design
  static const Duration fastAnimation = Duration(milliseconds: 120);
  static const Duration standardAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  /// Border radius constants for consistent shape language
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  /// Elevation constants for consistent depth
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
}