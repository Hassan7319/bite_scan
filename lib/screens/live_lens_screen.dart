import 'package:flutter/material.dart';
import 'package:bite_scan/screens/capture_item_screen.dart';
import 'package:bite_scan/routes.dart';

class LiveLensScreen extends StatelessWidget {
  const LiveLensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00B894),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
        ),
        title: const Text(
          'Household Shortcut',
          style: TextStyle(
            color: Color(0xFF1E272E),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1FDF8),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Positioned(top: 40, left: 40, child: _ViewfinderCorner(quarterTurns: 0)),
                              const Positioned(top: 40, right: 40, child: _ViewfinderCorner(quarterTurns: 1)),
                              const Positioned(bottom: 40, right: 40, child: _ViewfinderCorner(quarterTurns: 2)),
                              const Positioned(bottom: 40, left: 40, child: _ViewfinderCorner(quarterTurns: 3)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.filter_center_focus_outlined,
                                    size: 80,
                                    color: const Color(0xFF00B894).withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Position item in frame',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF7F8C8D),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) => const CaptureItemScreen(),
                          );
                        },
                        icon: const Icon(Icons.fullscreen, color: Colors.white),
                        label: const Text('Scan Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B894),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'QUICK TIPS',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(child: _buildTipCard(Icons.camera_alt_outlined, 'Clear photo', const Color(0xFFE2F0D9))),
                          const SizedBox(width: 8),
                          Expanded(child: _buildTipCard(Icons.lightbulb_outline, 'Good light', const Color(0xFFFEF9E7))),
                          const SizedBox(width: 8),
                          Expanded(child: _buildTipCard(Icons.track_changes, 'Fill frame', const Color(0xFFFADBD8))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipCard(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black87, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _ViewfinderCorner extends StatelessWidget {
  final int quarterTurns;
  const _ViewfinderCorner({required this.quarterTurns});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF00B894), width: 4),
            left: BorderSide(color: Color(0xFF00B894), width: 4),
          ),
        ),
      ),
    );
  }
}
