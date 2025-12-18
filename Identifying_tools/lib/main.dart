import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_package;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:math';

import 'dart:developer' as devtools;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for Android only
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tool Identifier',
      debugShowCheckedModeBanner: false, // Remove DEBUG banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// Home Page - Premium Design
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.blue.shade600,
              Colors.cyan.shade600,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.cyan.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // App Icon/Logo with glassmorphism
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            final double safe = (value).clamp(0.0, 1.0) as double;
                            return Transform.scale(
                              scale: 0.8 + (0.2 * safe),
                              child: Opacity(opacity: safe, child: child),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: const Offset(0, 15),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.build_rounded,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // App Title with animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 1000),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            final double safe = (value).clamp(0.0, 1.0) as double;
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - safe)),
                              child: Opacity(opacity: safe, child: child),
                            );
                          },
                          child: const Text(
                            'Tool Identifier',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.0,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Description with animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 1200),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            final double safe = (value).clamp(0.0, 1.0) as double;
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - safe)),
                              child: Opacity(opacity: safe, child: child),
                            );
                          },
                          child: Text(
                            'Identify tools instantly using AI\npowered image recognition',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white.withOpacity(0.95),
                              height: 1.6,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        // Get Started Button with glassmorphism
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 1400),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            final double safe = (value).clamp(0.0, 1.0) as double;
                            return Transform.scale(
                              scale: 0.9 + (0.1 * safe),
                              child: Opacity(opacity: safe, child: child),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ToolsListPage(),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 48,
                                    vertical: 20,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Get Started',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1E40AF),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 24,
                                        color: Color(0xFF1E40AF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        
                        // Swipeable Tool Images Carousel with improved design
                        SizedBox(
                          height: 240,
                          child: PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              final toolImages = [
                                'assets/Locking plier.jpg',
                                'assets/Open end wranch.jpg',
                                'assets/Torque Wrench.jpg',
                                'assets/Nindle nose flier.jpg',
                                'assets/Star screw driver.jpg',
                                'assets/Flat screw driver.jpg',
                                'assets/Cobination wranch.jpg',
                                'assets/Hammer.jpg',
                                'assets/Adjustable.jpg',
                                'assets/Nut driver.jpg',
                              ];

                              final toolNames = [
                                'Locking Plier',
                                'Open End Wrench',
                                'Torque Wrench',
                                'Needle Nose Plier',
                                'Star Screwdriver',
                                'Flat Screwdriver',
                                'Combination Wrench',
                                'Hammer',
                                'Adjustable Wrench',
                                'Nut Driver',
                              ];

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.white.withOpacity(0.12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 12),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white.withOpacity(0.2),
                                              Colors.white.withOpacity(0.05),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.asset(
                                            toolImages[index],
                                            fit: BoxFit.contain,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: const Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: 64,
                                                  color: Colors.white70,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      // Tool name overlay
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.8),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  toolNames[index],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 0.5,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors.black54,
                                                        offset: Offset(0, 2),
                                                        blurRadius: 4,
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Page indicator dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(10, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                boxShadow: _currentPage == index
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : [],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        
                        // Swipe hint
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Swipe to explore tools',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Features with improved design
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _FeatureItem(
                              icon: Icons.camera_alt_rounded,
                              label: 'Scan',
                            ),
                            _FeatureItem(
                              icon: Icons.history_rounded,
                              label: 'History',
                            ),
                            _FeatureItem(
                              icon: Icons.bar_chart_rounded,
                              label: 'Stats',
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Updated ToolsListPage with Sidebar Navigation
class ToolsListPage extends StatelessWidget {
  const ToolsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tool Classes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade800,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.build_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tool Identifier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerMenuItem(
                icon: Icons.camera_alt,
                title: 'Scan with Camera',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
              ),
              _DrawerMenuItem(
                icon: Icons.history,
                title: 'Scan History',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
              ),
              _DrawerMenuItem(
                icon: Icons.bar_chart,
                title: 'Statistics',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsPage(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white30, thickness: 1, height: 30),
              _DrawerMenuItem(
                icon: Icons.list,
                title: 'Tool Classes',
                onTap: () {
                  Navigator.pop(context);
                },
                isActive: true,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Tool Classes:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 28),
                    SizedBox(width: 16),
                    Text(
                      'Proceed to Camera',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    _ToolListItem(label: 'Locking Plier'),
                    _ToolListItem(label: 'Open End Wrench'),
                    _ToolListItem(label: 'Torque Wrench'),
                    _ToolListItem(label: 'Needle Nose Plier'),
                    _ToolListItem(label: 'Star Screwdriver'),
                    _ToolListItem(label: 'Flat Screwdriver'),
                    _ToolListItem(label: 'Combination Wrench'),
                    _ToolListItem(label: 'Hammer'),
                    _ToolListItem(label: 'Adjustable Wrench'),
                    _ToolListItem(label: 'Nut Driver'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Drawer Menu Item Widget
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Tool List Item for the column layout
class _ToolListItem extends StatelessWidget {
  final String label;

  const _ToolListItem({required this.label});

  // Map tool labels to asset image paths
  String _getImagePath(String label) {
    final imageMap = {
      'Locking Plier': 'assets/Locking plier.jpg',
      'Open End Wrench': 'assets/Open end wranch.jpg',
      'Torque Wrench': 'assets/Torque Wrench.jpg',
      'Needle Nose Plier': 'assets/Nindle nose flier.jpg',
      'Star Screwdriver': 'assets/Star screw driver.jpg',
      'Flat Screwdriver': 'assets/Flat screw driver.jpg',
      'Combination Wrench': 'assets/Cobination wranch.jpg',
      'Hammer': 'assets/Hammer.jpg',
      'Adjustable Wrench': 'assets/Adjustable.jpg',
      'Nut Driver': 'assets/Nut driver.jpg',
    };
    return imageMap[label] ?? 'assets/upload.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ToolDetailPage(label: label)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Attractive Image Container
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  _getImagePath(label),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Database Helper Class
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scan_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = path_package.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT NOT NULL,
        confidence REAL NOT NULL,
        image_path TEXT NOT NULL,
        date_time TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertScan(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('scan_history', row);
  }

  Future<List<Map<String, dynamic>>> getAllScans() async {
    final db = await instance.database;
    return await db.query('scan_history', orderBy: 'date_time DESC');
  }

  Future<int> deleteScan(int id) async {
    final db = await instance.database;
    return await db.delete('scan_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllScans() async {
    final db = await instance.database;
    return await db.delete('scan_history');
  }

  // Normalize label - trim and handle variations
  static String _normalizeLabel(String label) {
    return label.trim();
  }

  // Get statistics for charts
  Future<Map<String, int>> getLabelCounts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT label, COUNT(*) as count 
      FROM scan_history 
      GROUP BY label 
      ORDER BY count DESC
    ''');
    
    Map<String, int> labelCounts = {};
    for (var row in results) {
      final rawLabel = row['label'] as String;
      final normalizedLabel = _normalizeLabel(rawLabel);
      labelCounts[normalizedLabel] = (labelCounts[normalizedLabel] ?? 0) + (row['count'] as int);
    }
    return labelCounts;
  }

  Future<Map<String, double>> getAverageConfidence() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT label, AVG(confidence) as avg_confidence 
      FROM scan_history 
      GROUP BY label 
      ORDER BY avg_confidence DESC
    ''');
    
    Map<String, double> avgConfidence = {};
    for (var row in results) {
      avgConfidence[row['label']] = row['avg_confidence'] as double;
    }
    return avgConfidence;
  }
}

class MyHomePage extends StatefulWidget {
  final String? initialTool;
  const MyHomePage({super.key, this.initialTool});

  @override
  State<MyHomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyHomePage> {
  File? filePath;
  String label = "";
  double confidence = 0.0;
  List<dynamic>? recognitions;

  Future<void> _tfiteInit() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<void> _saveToHistory() async {
    if (filePath != null && label.isNotEmpty) {
      // Calculate normalized accuracy (same as displayed)
      final norm = _computeNormalizedMap();
      final canonical = _canonicalKeyFor(label, const [
        'Locking Plier',
        'Open End Wrench',
        'Torque Wrench',
        'Needle Nose Plier',
        'Star Screwdriver',
        'Flat Screwdriver',
        'Combination Wrench',
        'Hammer',
        'Adjustable Wrench',
        'Nut Driver',
      ]);
      final displayedAccuracy = (norm.containsKey(canonical))
          ? norm[canonical]!.roundToDouble()
          : confidence.roundToDouble();
      
      // Save to local SQLite database
      await DatabaseHelper.instance.insertScan({
        'label': label,
        'confidence': confidence,
        'image_path': filePath!.path,
        'date_time': DateTime.now().toIso8601String(),
      });

      // Save to Firebase Firestore with normalized/rounded accuracy (same as displayed)
      try {
        final firestore = FirebaseFirestore.instance;
        final now = DateTime.now();
        
        // Save each scan as a new document in the collection
        await firestore.collection('kumar-tools').add({
          'Accuracy_rate': displayedAccuracy,
          'ClassType': label,
          'Time': Timestamp.fromDate(now),
        });
        
        devtools.log('Successfully saved to Firestore: $label with ${displayedAccuracy}% accuracy');
      } catch (e) {
        devtools.log('Error saving to Firestore: $e');
      }
    }
  }

  pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recs = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 10,
      threshold: 0.01,
      asynch: true,
    );

    if (recs == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recs.toString());
    setState(() {
      recognitions = recs;
      confidence = (recs[0]['confidence'] * 100);
      label = recs[0]['label'].toString();
    });

    // Save to history
    await _saveToHistory();
  }

  pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recs = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 10,
      threshold: 0.01,
      asynch: true,
    );

    if (recs == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recs.toString());
    setState(() {
      recognitions = recs;
      confidence = (recs[0]['confidence'] * 100);
      label = recs[0]['label'].toString();
    });

    // Save to history
    await _saveToHistory();
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  @override
  void initState() {
    super.initState();
    _tfiteInit();
    // If opened with an initial tool, set the label so the scanner shows it
    if (widget.initialTool != null && widget.initialTool!.isNotEmpty) {
      label = widget.initialTool!;
      confidence = 0.0;
    }
  }

  // Normalize a raw label string: lowercase, remove punctuation
  String _clean(String s) => s.replaceAll(RegExp(r"[^a-z0-9 ]"), '').toLowerCase();

  // Correct common misspellings coming from asset names / labels
  String _correctCommon(String s) {
    var t = s.toLowerCase();
    final Map<String, String> fixes = {
      'wranch': 'wrench',
      'wrnch': 'wrench',
      'cobination': 'combination',
      'nindle': 'needle',
      'flier': 'plier',
      'flier': 'plier',
      'plirs': 'pliers',
      'plie r': 'plier',
      // screwdriver variants
      'screw driver': 'screwdriver',
      'screw-driver': 'screwdriver',
      'screwdrivier': 'screwdriver',
      'screw drivier': 'screwdriver',
      'star screw': 'star screwdriver',
      'flat screw': 'flat screwdriver',
    };
    fixes.forEach((k, v) {
      t = t.replaceAll(k, v);
    });
    return t;
  }


  // Map a raw recognition label to the canonical key used in allTools
  String _canonicalKeyFor(String raw, List<String> allTools) {
    final cleaned = _clean(_correctCommon(raw)).replaceAll('_', ' ').trim();
    final cleanedNoSpace = cleaned.replaceAll(' ', '');
    // Explicit keyword mapping for common screwdriver phrases
    if (cleaned.contains('star') && cleaned.contains('screw')) return 'star screwdriver';
    if (cleaned.contains('flat') && cleaned.contains('screw')) return 'flat screwdriver';
    // exact / normalized match first
    for (var tool in allTools) {
      final toolClean = _clean(tool).trim();
      final toolNoSpace = toolClean.replaceAll(' ', '');
      if (cleanedNoSpace == toolNoSpace) return tool.trim().toLowerCase();
      if (cleaned == toolClean) return tool.trim().toLowerCase();
      if (cleanedNoSpace.contains(toolNoSpace) || toolNoSpace.contains(cleanedNoSpace)) {
        return tool.trim().toLowerCase();
      }
    }
    // token-based match: prefer non-generic tokens
    final Set<String> typeWords = {
      'wrench', 'driver', 'screwdriver', 'screw', 'pliers', 'plier', 'nut', 'hammer', 'adjustable', 'open', 'end', 'combination', 'torque', 'needle', 'star', 'flat'
    };
    final tokens = cleaned.split(RegExp(r'\s+')).where((t) => t.length > 2).toSet();
    String? best;
    int bestScore = 0;
    for (var tool in allTools) {
      final tTokens = _clean(_correctCommon(tool)).split(RegExp(r'\s+')).where((t) => t.length > 2).toSet();
      final intersect = tokens.intersection(tTokens);
      if (intersect.isEmpty) continue;
      // discard matches that are purely generic type words
      final onlyType = intersect.every((w) => typeWords.contains(w));
      if (onlyType) continue;
      if (intersect.length > bestScore) {
        bestScore = intersect.length;
        best = tool.trim().toLowerCase();
      }
    }
    return best ?? cleaned;
  }

  // Compute normalized map (canonical -> percent) using recognitions
  Map<String, double> _computeNormalizedMap() {
    const List<String> allTools = [
      'Locking Plier',
      'Open End Wrench',
      'Torque Wrench',
      'Needle Nose Plier',
      'Star Screwdriver',
      'Flat Screwdriver',
      'Combination Wrench',
      'Hammer',
      'Adjustable Wrench',
      'Nut Driver',
    ];

    final Map<String, double> original = {};
    if (recognitions != null && recognitions!.isNotEmpty) {
      for (var e in recognitions!) {
        final raw = e['label'].toString();
        final key = _canonicalKeyFor(raw, allTools);
        original[key] = (e['confidence'] as num) * 100.0;
      }
    }

    // Build canonical working map with default 0
    final Map<String, double> working = {};
    for (var tool in allTools) {
      working[tool.trim().toLowerCase()] = 0.0;
    }
    // assign known original values
    for (var entry in original.entries) {
      // if entry.key exactly matches a canonical key, use it
      if (working.containsKey(entry.key)) {
        working[entry.key] = entry.value;
      } else {
        // try to fuzzy match again to canonical names
        for (var tool in allTools) {
          final can = tool.trim().toLowerCase();
          if (can.contains(entry.key) || entry.key.contains(can)) {
            working[can] = max(working[can]!, entry.value);
          }
        }
      }
    }

    final double sum = working.values.fold(0.0, (a, b) => a + b);
    final Map<String, double> normalized = {};
    if (sum > 0) {
      final double maxVal = working.values.reduce((a, b) => a > b ? a : b);
      if (maxVal / sum >= 0.98) {
        String maxKey = working.entries.firstWhere((e) => e.value == maxVal).key;
        for (var k in working.keys) normalized[k] = (k == maxKey) ? 100.0 : 0.0;
      } else {
        for (var entry in working.entries) {
          normalized[entry.key] = (entry.value / sum) * 100.0;
        }
      }
    } else {
      for (var k in working.keys) normalized[k] = 0.0;
    }
    return normalized;
  }

  // Teachable Machine style VERTICAL bars (columns) for current predictions — show ALL classes
  Widget _buildPredictionBars() {
    const List<String> allTools = [
      'Locking Plier',
      'Open End Wrench',
      'Torque Wrench',
      'Needle Nose Plier',
      'Star Screwdriver',
      'Flat Screwdriver',
      'Combination Wrench',
      'Hammer',
      'Adjustable Wrench',
      'Nut Driver',
    ];

    // Use centralized normalization helper so both bars and accuracy text align
    final normalizedMap = _computeNormalizedMap();

    double _findConfidence(String tool) {
      final key = tool.trim().toLowerCase();
      if (normalizedMap.containsKey(key)) return normalizedMap[key]!;
      for (var k in normalizedMap.keys) {
        if (k.contains(key) || key.contains(k)) return normalizedMap[k]!;
      }
      return 0.0;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: allTools.map((tool) {
          final double pct = _findConfidence(tool).clamp(0.0, 100.0);
          final bool hasData = pct > 0.0;
          final double barHeight = 180 * (pct / 100.0).clamp(0.0, 1.0);
          
          return Expanded(
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 600 + (allTools.indexOf(tool) * 50)),
              tween: Tween(begin: 0.0, end: barHeight),
              curve: Curves.easeOutCubic,
              builder: (context, animatedHeight, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Percentage badge above the bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: hasData 
                            ? Colors.blue.shade50 
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: hasData 
                              ? Colors.blue.shade200 
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${pct.toStringAsFixed(0)}\u00A0%',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: hasData 
                              ? Colors.blue.shade700 
                              : Colors.grey.shade600,
                          letterSpacing: 0.2,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Animated Vertical bar with gradient
                    Container(
                      width: 28,
                      height: animatedHeight.clamp(0.0, 180.0),
                      decoration: BoxDecoration(
                        gradient: hasData
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade600,
                                  Colors.blue.shade700,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              )
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade400,
                                ],
                              ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                          bottom: Radius.circular(12),
                        ),
                        boxShadow: hasData
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tool label below the bar
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Text(
                        tool,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: hasData ? FontWeight.w700 : FontWeight.w600,
                          color: hasData 
                              ? const Color(0xFF1E293B) 
                              : Colors.grey.shade600,
                          letterSpacing: 0.1,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identify Tools"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade800,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.build_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tool Identifier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerMenuItem(
                icon: Icons.camera_alt,
                title: 'Scan with Camera',
                onTap: () {
                  Navigator.pop(context);
                },
                isActive: true,
              ),
              _DrawerMenuItem(
                icon: Icons.history,
                title: 'Scan History',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
              ),
              _DrawerMenuItem(
                icon: Icons.bar_chart,
                title: 'Statistics',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsPage(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white30, thickness: 1, height: 30),
              _DrawerMenuItem(
                icon: Icons.list,
                title: 'Tool Classes',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ToolsListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              sizedBox,
              Card(
                elevation: 24,
                shadowColor: Colors.blue.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          height: 280,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            image: const DecorationImage(
                              image: AssetImage('assets/upload.jpg'),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: filePath == null
                              ? const Text('')
                              : Image.file(
                                  filePath!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Builder(builder: (context) {
                                // compute normalized percent for displayed label so text matches graph
                                final norm = _computeNormalizedMap();
                                final canonical = _canonicalKeyFor(label, const [
                                  'Locking Plier',
                                  'Open End Wrench',
                                  'Torque Wrench',
                                  'Needle Nose Plier',
                                  'Star Screwdriver',
                                  'Flat Screwdriver',
                                  'Combination Wrench',
                                  'Hammer',
                                  'Adjustable Wrench',
                                  'Nut Driver',
                                ]);
                                final pct = (norm.containsKey(canonical))
                                    ? norm[canonical]!.round()
                                    : confidence.toStringAsFixed(0);
                                final display = pct is int ? '$pct%' : '$pct%';
                                return Text(
                                  'The Accuracy is $display',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 18),
                                );
                              }),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Modern Action Buttons - Side by Side
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 400),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          final double safe = (value).clamp(0.0, 1.0) as double;
                          return Transform.scale(
                            scale: 0.9 + (0.1 * safe),
                            child: Opacity(opacity: safe, child: child),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue.shade600,
                                Colors.blue.shade800,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                pickImageCamera();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.25),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'Take Photo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          final double safe = (value).clamp(0.0, 1.0) as double;
                          return Transform.scale(
                            scale: 0.9 + (0.1 * safe),
                            child: Opacity(opacity: safe, child: child),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                pickImageGallery();
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.image_rounded,
                                        color: Colors.blue.shade700,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'From Gallery',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Enhanced Prediction Graph with Modern Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade400, Colors.blue.shade600],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.bar_chart_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Prediction Confidence',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: min(300.0, MediaQuery.of(context).size.height * 0.38),
                        child: _buildPredictionBars(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// Statistics Page
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  Map<String, int> _labelCounts = {};
  Map<String, double> _avgConfidence = {};
  bool _isLoading = true;

  // All 10 tool classes
  static const List<String> _toolClasses = [
    'Locking Plier',
    'Open End Wrench',
    'Torque Wrench',
    'Needle Nose Plier',
    'Star Screwdriver',
    'Flat Screwdriver',
    'Combination Wrench',
    'Hammer',
    'Adjustable Wrench',
    'Nut Driver',
  ];

  // Mapping from model labels to standardized tool class names
  static const Map<String, String> _labelMapping = {
    // Locking Plier variations
    'Locking Plier': 'Locking Plier',
    'LockingPlier': 'Locking Plier',
    'Locking Pliers': 'Locking Plier',
    'LockingPliers': 'Locking Plier',
    'Locking_Plier': 'Locking Plier',
    'locking plier': 'Locking Plier',
    'lockingplier': 'Locking Plier',
    'Locking': 'Locking Plier',
    
    // Open End Wrench variations
    'Open End Wrench': 'Open End Wrench',
    'OpenEndWrench': 'Open End Wrench',
    'Open_End_Wrench': 'Open End Wrench',
    'Open End': 'Open End Wrench',
    'open end wrench': 'Open End Wrench',
    'openendwrench': 'Open End Wrench',
    'OpenEnd': 'Open End Wrench',
    
    // Torque Wrench variations
    'Torque Wrench': 'Torque Wrench',
    'TorqueWrench': 'Torque Wrench',
    'Torque_Wrench': 'Torque Wrench',
    'torque wrench': 'Torque Wrench',
    'torquewrench': 'Torque Wrench',
    'Torque': 'Torque Wrench',
    
    // Needle Nose Plier variations
    'Needle Nose Plier': 'Needle Nose Plier',
    'NeedleNosePlier': 'Needle Nose Plier',
    'Needle Nose Pliers': 'Needle Nose Plier',
    'NeedleNosePliers': 'Needle Nose Plier',
    'Needle_Nose_Plier': 'Needle Nose Plier',
    'needle nose plier': 'Needle Nose Plier',
    'needlenoseplier': 'Needle Nose Plier',
    'Needle Nose': 'Needle Nose Plier',
    'NeedleNose': 'Needle Nose Plier',
    
    // Star Screwdriver variations
    'Star Screwdriver': 'Star Screwdriver',
    'StarScrewdriver': 'Star Screwdriver',
    'Star_Screwdriver': 'Star Screwdriver',
    'Star': 'Star Screwdriver',
    'star screwdriver': 'Star Screwdriver',
    'starscrewdriver': 'Star Screwdriver',
    'Star Screw': 'Star Screwdriver',
    
    // Flat Screwdriver variations
    'Flat Screwdriver': 'Flat Screwdriver',
    'FlatScrewdriver': 'Flat Screwdriver',
    'Flat_Screwdriver': 'Flat Screwdriver',
    'Flat': 'Flat Screwdriver',
    'flat screwdriver': 'Flat Screwdriver',
    'flatscrewdriver': 'Flat Screwdriver',
    'Flat Screw': 'Flat Screwdriver',
    
    // Combination Wrench variations
    'Combination Wrench': 'Combination Wrench',
    'CombinationWrench': 'Combination Wrench',
    'Combination_Wrench': 'Combination Wrench',
    'Combination Tools': 'Combination Wrench',
    'CombinationTools': 'Combination Wrench',
    'Combination': 'Combination Wrench',
    'combination wrench': 'Combination Wrench',
    'combinationwrench': 'Combination Wrench',
    'Combination Tool': 'Combination Wrench',
    'CombinationTool': 'Combination Wrench',
    
    // Hammer variations
    'Hammer': 'Hammer',
    'hammer': 'Hammer',
    'HAMMER': 'Hammer',
    
    // Adjustable Wrench variations
    'Adjustable Wrench': 'Adjustable Wrench',
    'AdjustableWrench': 'Adjustable Wrench',
    'Adjustable_Wrench': 'Adjustable Wrench',
    'Adjustable': 'Adjustable Wrench',
    'adjustable wrench': 'Adjustable Wrench',
    'adjustablewrench': 'Adjustable Wrench',
    
    // Nut Driver variations
    'Nut Driver': 'Nut Driver',
    'NutDriver': 'Nut Driver',
    'Nut_Driver': 'Nut Driver',
    'Nut': 'Nut Driver',
    'nut driver': 'Nut Driver',
    'nutdriver': 'Nut Driver',
    // Common misspellings / labels from user's labels.txt
    'Locking flier': 'Locking Plier',
    'Open end wranch': 'Open End Wrench',
    'Nindle nose flier': 'Needle Nose Plier',
    'Star Screw drivier': 'Star Screwdriver',
    'Flat screw drivier': 'Flat Screwdriver',
    'Cobination wranch': 'Combination Wrench',
  };

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when page becomes visible (but only once per frame)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadStatistics();
      }
    });
  }

  Future<void> _loadStatistics() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    final counts = await DatabaseHelper.instance.getLabelCounts();
    final avgConf = await DatabaseHelper.instance.getAverageConfidence();
    
    // Normalize labels to match tool classes
    Map<String, int> normalizedCounts = {};
    for (var entry in counts.entries) {
      final matchingClass = _findMatchingToolClass(entry.key);
      if (matchingClass != null) {
        normalizedCounts[matchingClass] = (normalizedCounts[matchingClass] ?? 0) + entry.value;
      } else {
        // Debug: print unmapped labels
        devtools.log('Unmapped label: "${entry.key}"');
      }
    }
    
    if (mounted) {
      setState(() {
        _labelCounts = normalizedCounts;
        _avgConfidence = avgConf;
        _isLoading = false;
      });
    }
  }

  List<Color> _generateColors(int count) {
    return List.generate(count, (index) {
      final hue = (index * 360 / count) % 360;
      return HSVColor.fromAHSV(1.0, hue, 0.7, 0.9).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade800,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.build_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tool Identifier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerMenuItem(
                icon: Icons.camera_alt,
                title: 'Scan with Camera',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
              ),
              _DrawerMenuItem(
                icon: Icons.history,
                title: 'Scan History',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryPage(),
                    ),
                  );
                },
              ),
              _DrawerMenuItem(
                icon: Icons.bar_chart,
                title: 'Statistics',
                onTap: () {
                  Navigator.pop(context);
                },
                isActive: true,
              ),
              const Divider(color: Colors.white30, thickness: 1, height: 30),
              _DrawerMenuItem(
                icon: Icons.list,
                title: 'Tool Classes',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ToolsListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _labelCounts.isEmpty
              ? const Center(
                  child: Text(
                    'No data available yet.\nStart scanning tools!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Scans Card
                      Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.qr_code_scanner, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_labelCounts.values.reduce((a, b) => a + b)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Total Scans'),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.category, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${_labelCounts.length}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Tool Types'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Visualization Title
                      const Text(
                        'Visualization',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Line Chart Card
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            height: 400,
                            child: _buildLineChart(),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      _buildLineChartLegend(),
                      
                      const SizedBox(height: 32),
                      
                      // Detailed Data Section
                      const Text(
                        'Detailed Data',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Data Table
                      _buildDataTable(),
                    ],
                  ),
                ),
    );
  }

  // Helper method to find matching tool class (handles variations)
  String? _findMatchingToolClass(String label) {
    final normalizedLabel = label.trim();
    
    // First, check the mapping dictionary
    if (_labelMapping.containsKey(normalizedLabel)) {
      return _labelMapping[normalizedLabel];
    }
    
    // Check case-insensitive mapping
    for (var entry in _labelMapping.entries) {
      if (entry.key.toLowerCase() == normalizedLabel.toLowerCase()) {
        return entry.value;
      }
    }
    
    // Exact match with tool classes
    for (var toolClass in _toolClasses) {
      if (toolClass.trim().toLowerCase() == normalizedLabel.toLowerCase()) {
        return toolClass;
      }
    }
    
    // Partial match (in case of extra spaces or slight variations)
    for (var toolClass in _toolClasses) {
      final toolClassLower = toolClass.trim().toLowerCase();
      final labelLower = normalizedLabel.toLowerCase();
      
      // Check if label contains tool class name or vice versa
      if (toolClassLower.contains(labelLower) || labelLower.contains(toolClassLower)) {
        // Make sure it's a meaningful match (not just single letters)
        if (labelLower.length >= 3 || toolClassLower.length >= 3) {
          return toolClass;
        }
      }
    }
    
    // Last resort: try to match key words
    final labelWords = normalizedLabel.toLowerCase().split(RegExp(r'[\s_]+'));
    for (var toolClass in _toolClasses) {
      final toolClassWords = toolClass.toLowerCase().split(' ');
      // Check if most words match
      int matchCount = 0;
      for (var word in labelWords) {
        if (word.length >= 3 && toolClassWords.any((tc) => tc.contains(word) || word.contains(tc))) {
          matchCount++;
        }
      }
      if (matchCount >= 1 && matchCount >= labelWords.length / 2) {
        return toolClass;
      }
    }
    
    return null;
  }

  Widget _buildLineChart() {
    // Get counts for each tool class - ensure all 10 classes are shown
    // _labelCounts is already normalized in _loadStatistics
    final spots = _toolClasses.asMap().entries.map((entry) {
      final index = entry.key;
      final toolClass = entry.value;
      final count = _labelCounts[toolClass] ?? 0;
      return FlSpot(index.toDouble(), count.toDouble());
    }).toList();

    // Calculate maxY - ensure it's at least 1 to show the graph properly
    double maxY = 10.0;
    if (_labelCounts.isNotEmpty) {
      final maxCount = _labelCounts.values.reduce((a, b) => a > b ? a : b);
      maxY = (maxCount.toDouble() * 1.2).ceilToDouble();
      if (maxY < 1) maxY = 10.0;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? (maxY / 10).ceilToDouble() : 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 100,
              interval: 1, // Show every label
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < _toolClasses.length) {
                  final toolClass = _toolClasses[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Transform.rotate(
                      angle: -0.6,
                      child: SizedBox(
                        width: 80,
                        child: Text(
                          toolClass,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: maxY > 0 ? (maxY / 10).ceilToDouble() : 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        minX: 0,
        maxX: (_toolClasses.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.blue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                final toolIndex = touchedSpot.x.toInt();
                if (toolIndex >= 0 && toolIndex < _toolClasses.length) {
                  final toolClass = _toolClasses[toolIndex];
                  return LineTooltipItem(
                    '$toolClass\n${touchedSpot.y.toInt()} scans',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
      ),
    );
  }

  Widget _buildLineChartLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 20,
      runSpacing: 12,
      children: _toolClasses.asMap().entries.map((entry) {
        final toolClass = entry.value;
        final count = _labelCounts[toolClass] ?? 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$toolClass: $count',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDataTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(Colors.blue),
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          dataRowMinHeight: 50,
          dataRowMaxHeight: 60,
          columns: const [
            DataColumn(label: Text('Tool Class')),
            DataColumn(label: Text('Scan Count'), numeric: true),
          ],
          rows: _toolClasses.map((toolClass) {
            final count = _labelCounts[toolClass] ?? 0;
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    toolClass,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    count.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// History Page
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await DatabaseHelper.instance.getAllScans();
    setState(() {
      _history = data; // Already sorted DESC (newest first)
    });
  }

  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.instance.deleteScan(id);
    _loadHistory();
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to delete all scan history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deleteAllScans();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAll,
              tooltip: 'Clear All',
            ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade400,
                Colors.blue.shade800,
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.build_circle,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tool Identifier',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _DrawerMenuItem(
                icon: Icons.camera_alt,
                title: 'Scan with Camera',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
              ),
              _DrawerMenuItem(
                icon: Icons.history,
                title: 'Scan History',
                onTap: () {
                  Navigator.pop(context);
                },
                isActive: true,
              ),
              _DrawerMenuItem(
                icon: Icons.bar_chart,
                title: 'Statistics',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsPage(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white30, thickness: 1, height: 30),
              _DrawerMenuItem(
                icon: Icons.list,
                title: 'Tool Classes',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ToolsListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No scan history yet',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final dateTime = DateTime.parse(item['date_time']);
                final formattedDate = DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: item['image_path'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(item['image_path']),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image),
                                );
                              },
                            ),
                          )
                        : null,
                    title: Text(
                      item['label'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Accuracy: ${item['confidence'].toStringAsFixed(0)}%'),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(item['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ToolDetailPage extends StatelessWidget {
  final String label;

  const ToolDetailPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text(label),
      ),
      backgroundColor: Colors.blue.shade700,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Image mapping for tool classes
              Builder(builder: (ctx) {
                final imgMap = {
                  'Locking Plier': 'assets/Locking plier.jpg',
                  'Open End Wrench': 'assets/Open end wranch.jpg',
                  'Torque Wrench': 'assets/Torque Wrench.jpg',
                  'Needle Nose Plier': 'assets/Nindle nose flier.jpg',
                  'Star Screwdriver': 'assets/Star screw driver.jpg',
                  'Flat Screwdriver': 'assets/Flat screw driver.jpg',
                  'Combination Wrench': 'assets/Cobination wranch.jpg',
                  'Hammer': 'assets/Hammer.jpg',
                  'Adjustable Wrench': 'assets/Adjustable.jpg',
                  'Nut Driver': 'assets/Nut driver.jpg',
                };

                final desc = {
                  'Locking Plier': 'Locking pliers clamp onto objects and hold them tightly, useful for gripping and turning.',
                  'Open End Wrench': 'Open-end wrenches fit two sides of nuts and bolts for tightening or loosening.',
                  'Torque Wrench': 'Torque wrenches let you apply a precise amount of torque to fasteners.',
                  'Needle Nose Plier': 'Needle-nose pliers are good for reaching into tight spaces and bending wire.',
                  'Star Screwdriver': 'Star (Torx) screwdrivers fit star-shaped screw heads for better torque transfer.',
                  'Flat Screwdriver': 'Flat screwdrivers are for slotted screws and prying in a pinch.',
                  'Combination Wrench': 'Combination wrenches offer an open and boxed end for different uses.',
                  'Hammer': 'Hammers deliver impact force to drive nails or shape materials.',
                  'Adjustable Wrench': 'Adjustable wrenches adapt to different bolt sizes with a movable jaw.',
                  'Nut Driver': 'Nut drivers are like screwdrivers but for hexagonal nuts and bolts.',
                };

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(ctx).size.height * 0.35,
                        minHeight: 200,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(
                            imgMap[label] ?? 'assets/upload.jpg',
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            errorBuilder: (c, e, st) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 64),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        desc[label] ?? 'No description available for this tool.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  icon: const Icon(Icons.camera_alt, size: 28),
                  label: const Text(
                    'Scan Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyHomePage(initialTool: label)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
