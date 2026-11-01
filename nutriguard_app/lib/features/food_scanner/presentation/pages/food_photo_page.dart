import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'food_confirmation_page.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/services/food_recognition_service.dart';

class FoodPhotoPage extends StatefulWidget {
  const FoodPhotoPage({super.key});

  @override
  State<FoodPhotoPage> createState() => _FoodPhotoPageState();
}

class _FoodPhotoPageState extends State<FoodPhotoPage> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  bool _isPicking = false;

  bool _isRecognizing = false;

  final FoodRecognitionService _recognitionService = FoodRecognitionService();

  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return;

    setState(() {
      _isPicking = true;
    });

    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1600,
      );

      if (!mounted) return;

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to select photo. Check camera permission '
            'and try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Future<void> _recognizeFoodWithAI() async {
    if (_selectedImage == null || _isRecognizing) {
      return;
    }

    setState(() {
      _isRecognizing = true;
    });

    try {
      final result = await _recognitionService.recognizeFood(_selectedImage!);

      if (!mounted) return;

      if (result.foods.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No food was identified. Try another photo.'),
          ),
        );
        return;
      }

      final confirmedFoods = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(builder: (_) => FoodConfirmationPage(result: result)),
      );

      if (!mounted || confirmedFoods == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Confirmed: ${confirmedFoods.join(', ')}'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('AI recognition failed: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isRecognizing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFC),
      appBar: AppBar(title: const Text('Scan Food Photo'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Identify Food from a Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a clear picture of your meal or '
              'choose an existing photo.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),

            Container(
              height: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE0EFF2)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _selectedImage == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 70,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'No photo selected',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    )
                  : Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          const Center(child: Text('Unable to preview image')),
                    ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isPicking
                        ? null
                        : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isPicking
                        ? null
                        : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),

            if (_isPicking) ...[
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
            ],

            if (_selectedImage != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isRecognizing ? null : _recognizeFoodWithAI,
                icon: _isRecognizing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(
                  _isRecognizing
                      ? 'Recognizing Food...'
                      : 'Recognize Food with AI',
                ),
              ),
              const SizedBox(height: 8),
            ],

            if (_selectedImage != null) ...[
              const SizedBox(height: 22),
              const Text(
                'Photo selected successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI food recognition will be connected next. '
                'No photo has been uploaded.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
