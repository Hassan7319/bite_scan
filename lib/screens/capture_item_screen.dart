import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bite_scan/ai_service.dart';

class CaptureItemScreen extends StatefulWidget {
  const CaptureItemScreen({super.key});

  @override
  State<CaptureItemScreen> createState() => _CaptureItemScreenState();
}

class _CaptureItemScreenState extends State<CaptureItemScreen> {
  XFile? _pickedFile;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  String? _aiResponse;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (file != null) {
        setState(() {
          _pickedFile = file;
          _aiResponse = null;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _handleAnalyze() async {
    if (_pickedFile == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      String result;
      if (kIsWeb) {
        final bytes = await _pickedFile!.readAsBytes();
        result = await AIService.analyzeItemWeb(bytes);
      } else {
        result = await AIService.analyzeItem(File(_pickedFile!.path));
      }
      
      setState(() {
        _aiResponse = result;
      });
    } catch (e) {
      setState(() {
        _aiResponse = "Error analyzing image: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildImagePlaceholder(),
                        const SizedBox(height: 20),
                        if (_aiResponse != null) _buildAIResponse(),
                        const SizedBox(height: 20),
                        _buildButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIResponse() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FDF8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00B894).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF00B894), size: 18),
              const SizedBox(width: 8),
              const Text(
                'BITESCAN AI',
                style: TextStyle(
                  color: Color(0xFF00B894),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _aiResponse!,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E272E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_isAnalyzing) {
      return const Column(
        children: [
          CircularProgressIndicator(color: Color(0xFF00B894)),
          SizedBox(height: 12),
          Text('AI is analyzing...', style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    if (_pickedFile == null) {
      return _buildInitialButtons();
    }

    return _buildActionButtons();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Capture Item',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E272E),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          style: _pickedFile == null ? BorderStyle.solid : BorderStyle.none,
        ),
      ),
      child: _pickedFile == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 48,
                  color: const Color(0xFF94A3B8).withOpacity(0.5),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No image selected',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: kIsWeb
                  ? Image.network(
                      _pickedFile!.path,
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      File(_pickedFile!.path),
                      fit: BoxFit.contain,
                    ),
            ),
    );
  }

  Widget _buildInitialButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt, size: 18),
            label: const Text('Take Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.upload, size: 18),
            label: const Text('Upload'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => setState(() {
              _pickedFile = null;
              _aiResponse = null;
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF64748B),
              side: const BorderSide(color: Color(0xFFE2E8F0)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Retake'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _aiResponse != null ? null : _handleAnalyze,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Analyze', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
