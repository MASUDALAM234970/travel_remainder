import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../common_widgets/primary_button.dart';
import '../../../common_widgets/secondary_button.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Image section
              Expanded(
                flex: 5,
                child: _buildImageSection(),
              ),

              // Content section
              Expanded(
                flex: 5,
                child: _buildContentSection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          child: _buildRoadSceneImage(),
        ),
      ],
    );
  }

  Widget _buildRoadSceneImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Sky
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF5AAFD4),
                Color(0xFF8CC5E0),
                Color(0xFFADD8EE),
              ],
            ),
          ),
        ),
        // Red rock formations (background)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(double.infinity, 300),
            painter: _RedRocksPainter(),
          ),
        ),
        // Road
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(double.infinity, 180),
            painter: _RoadPainter(),
          ),
        ),
        // Desert vegetation
        Positioned(
          bottom: 60,
          left: 20,
          child: CustomPaint(
            size: const Size(60, 40),
            painter: _BushPainter(),
          ),
        ),
        Positioned(
          bottom: 55,
          right: 40,
          child: CustomPaint(
            size: const Size(50, 35),
            painter: _BushPainter(),
          ),
        ),
        // Van
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Center(
            child: CustomPaint(
              size: const Size(80, 60),
              painter: _VanPainter(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome! Your Smart\nTravel Alarm',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Stay on schedule and enjoy every moment of your journey.',
            style: AppTextStyles.bodyLarge,
          ),
          const Spacer(),

          // Error message
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.4)),
                ),
                child: Text(
                  controller.errorMessage.value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.redAccent,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Location status
          Obx(() {
            if (controller.hasLocation.value) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        controller.locationText.value,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Use Current Location button
          Obx(() => SecondaryButton(
                text: 'Use Current Location',
                icon: Icons.location_on_outlined,
                onTap: controller.isLoading.value
                    ? null
                    : controller.useCurrentLocation,
                isLoading: controller.isLoading.value,
              )),
          const SizedBox(height: 16),

          // Home Button
          PrimaryButton(
            text: 'Home',
            onTap: controller.goToHome,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RedRocksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rockPaint = Paint()
      ..color = const Color(0xFFB84A2E)
      ..style = PaintingStyle.fill;

    final darkRockPaint = Paint()
      ..color = const Color(0xFF8B2E15)
      ..style = PaintingStyle.fill;

    // Left rock formation
    final leftRock = Path();
    leftRock.moveTo(0, size.height);
    leftRock.lineTo(0, size.height * 0.5);
    leftRock.lineTo(size.width * 0.1, size.height * 0.2);
    leftRock.lineTo(size.width * 0.18, size.height * 0.35);
    leftRock.lineTo(size.width * 0.25, size.height * 0.1);
    leftRock.lineTo(size.width * 0.32, size.height * 0.3);
    leftRock.lineTo(size.width * 0.38, size.height * 0.0);
    leftRock.lineTo(size.width * 0.42, size.height * 0.25);
    leftRock.lineTo(size.width * 0.45, size.height);
    leftRock.close();
    canvas.drawPath(leftRock, rockPaint);

    // Right rock formation
    final rightRock = Path();
    rightRock.moveTo(size.width * 0.55, size.height);
    rightRock.lineTo(size.width * 0.55, size.height * 0.25);
    rightRock.lineTo(size.width * 0.62, size.height * 0.0);
    rightRock.lineTo(size.width * 0.68, size.height * 0.3);
    rightRock.lineTo(size.width * 0.75, size.height * 0.1);
    rightRock.lineTo(size.width * 0.82, size.height * 0.35);
    rightRock.lineTo(size.width * 0.9, size.height * 0.2);
    rightRock.lineTo(size.width, size.height * 0.5);
    rightRock.lineTo(size.width, size.height);
    rightRock.close();
    canvas.drawPath(rightRock, rockPaint);

    // Shadow details
    final leftShadow = Path();
    leftShadow.moveTo(size.width * 0.38, 0);
    leftShadow.lineTo(size.width * 0.42, size.height * 0.25);
    leftShadow.lineTo(size.width * 0.38, size.height * 0.1);
    leftShadow.close();
    canvas.drawPath(leftShadow, darkRockPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Road surface
    final roadPaint = Paint()
      ..color = const Color(0xFF5A5A5A)
      ..style = PaintingStyle.fill;

    final roadPath = Path();
    roadPath.moveTo(0, size.height);
    roadPath.lineTo(size.width * 0.3, 0);
    roadPath.lineTo(size.width * 0.7, 0);
    roadPath.lineTo(size.width, size.height);
    roadPath.close();
    canvas.drawPath(roadPath, roadPaint);

    // Road markings
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final t = i / 5;
      final yStart = size.height * t;
      final yEnd = size.height * (t + 0.08);
      final xStart = size.width * 0.5;
      canvas.drawLine(Offset(xStart, yStart), Offset(xStart, yEnd), linePaint);
    }

    // Road edges
    final edgePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.3, 0),
      Offset(0, size.height),
      edgePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width, size.height),
      edgePaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _BushPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7A8A4A)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.6), 12, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), 15, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 11, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _VanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Van body
    final bodyPaint = Paint()
      ..color = const Color(0xFFE8A030)
      ..style = PaintingStyle.fill;

    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.1, size.height * 0.7);
    bodyPath.lineTo(size.width * 0.1, size.height * 0.3);
    bodyPath.quadraticBezierTo(
      size.width * 0.12, size.height * 0.1,
      size.width * 0.3, size.height * 0.1,
    );
    bodyPath.lineTo(size.width * 0.85, size.height * 0.1);
    bodyPath.quadraticBezierTo(
      size.width, size.height * 0.1,
      size.width, size.height * 0.3,
    );
    bodyPath.lineTo(size.width, size.height * 0.7);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Roof rack
    final rackPaint = Paint()
      ..color = const Color(0xFF5A3A1A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height * 0.12),
      rackPaint,
    );

    // Windows
    final windowPaint = Paint()
      ..color = const Color(0xFF2A2A4A).withOpacity(0.8)
      ..style = PaintingStyle.fill;

    final windowRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.18,
          size.width * 0.5, size.height * 0.28),
      const Radius.circular(4),
    );
    canvas.drawRRect(windowRRect, windowPaint);

    // Wheels
    final wheelPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * 0.82), 10, wheelPaint);
    canvas.drawCircle(
        Offset(size.width * 0.75, size.height * 0.82), 10, wheelPaint);

    // Wheel rims
    final rimPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * 0.82), 5, rimPaint);
    canvas.drawCircle(
        Offset(size.width * 0.75, size.height * 0.82), 5, rimPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
