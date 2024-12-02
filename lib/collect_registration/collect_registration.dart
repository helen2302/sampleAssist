import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CollectRegistration extends StatefulWidget {
  const CollectRegistration({super.key});

  @override
  State<CollectRegistration> createState() => _CollectRegistrationState();
}

class _CollectRegistrationState extends State<CollectRegistration> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPhotoIDType;
  final ImagePicker _imagePicker = ImagePicker();
  File? _uploadedPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collector Registration',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF01B4D2),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Step Indicator
            _buildStepIndicator(),

            const SizedBox(height: 16),

            // Collector Identity Section Title
            _buildSectionTitle('1. Collector Identity'),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PHOTO ID',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    // Photo ID Section
                    _buildPhotoIdSection(),

                    const SizedBox(height: 8),

                    // Photo ID Dropdown
                    _buildDropdownField(
                      'Please select a type of Photo ID',
                      ['Passport', 'Driver\'s License', 'National ID'],
                    ),

                    // Document Number & Expiry Date
                    _buildTextField('Photo ID Document Number'),
                    _buildTextField('Nationality'),
                    _buildTextField('Expiry Date'),

                    const SizedBox(height: 16),

                    // Personal Details Section
                    _buildSectionHeader('PERSONAL DETAILS'),
                    _buildTextField('First Name'),
                    _buildTextField('Last Name'),
                    _buildTextField('Sex'),
                    _buildTextField('Date of Birth'),

                    // Contact Information Section
                    const SizedBox(height: 16),
                    _buildSectionHeader('CONTACT INFORMATION'),
                    _buildTextField('Mobile Number'),
                    _buildTextField('Phone Number (Optional)'),
                    _buildTextField('Email Address'),

                    // Address Section
                    const SizedBox(height: 16),
                    _buildSectionHeader('ADDRESS'),
                    _buildTextField('Address Line 1 (Street address)'),
                    _buildTextField('Address Line 2 (Optional)'),
                    _buildTextField('City / Suburb'),
                    _buildTextField('State'),
                    _buildTextField('Postcode'),
                    _buildTextField('Country'),

                    // Confirm Buttons
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build step indicator
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor:
              index == 0 ? const Color(0xFF156CC9) : Colors.grey.shade300,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  color: index == 0 ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
            if (index != 4)
              Container(
                width: 40, // Line width
                height: 2,
                color: Colors.grey.shade300,
              ),
          ],
        );
      }),
    );
  }
  void _getPhotoFromGallery() async {
    try {
      final XFile? pickedFile =
      await _imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _uploadedPhoto = File(pickedFile.path); // Update the photo
        });
      }
    } catch (e) {
      print('Error selecting photo: $e');
    }
  }

  // Function to capture a photo from the camera
  void _takePhoto() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _uploadedPhoto = File(pickedFile.path); // Update the photo
        });
      }
    } catch (e) {
      print('Error capturing photo: $e');
    }
  }

  // Helper to build section title
  Widget _buildSectionTitle(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFF7F8E9D),
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  // Updated method to show photo ID options
  void _showPhotoIdOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(14.0),
              child: Text(
                'PHOTO ID OPTIONS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(height: 1), // Divider below the title

            // Watch Photo option
            if (_uploadedPhoto != null) ...[
              ListTile(
                leading: const Icon(Icons.visibility, color: Color(0xFF156CC9)),
                title: const Text(
                  'Watch Photo',
                  style: TextStyle(fontSize: 16, color: Color(0xFF156CC9)),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showFullPhotoDialog(); // Show full photo in a dialog
                },
              ),
              const Divider(height: 1),
            ],

            // Take Photo option
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF156CC9)),
              title: const Text(
                'Take Photo',
                style: TextStyle(fontSize: 16, color: Color(0xFF156CC9)),
              ),
              onTap: () {
                _takePhoto(); // Call the take photo function
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),

            // Upload Photo option
            ListTile(
              leading: const Icon(Icons.upload, color: Color(0xFF156CC9)),
              title: const Text(
                'Upload',
                style: TextStyle(fontSize: 16, color: Color(0xFF156CC9)),
              ),
              onTap: () {
                _getPhotoFromGallery(); // Handle "Upload" action
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),

            // Delete Photo option
            if (_uploadedPhoto != null) ...[
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.grey),
                title: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                onTap: () {
                  setState(() {
                    _uploadedPhoto = null; // Remove the uploaded photo
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
            ],

            // Close option
            ListTile(
              title: const Center(
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        );
      },
    );
  }

// Helper method to display the full photo in a dialog
  void _showFullPhotoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(
                _uploadedPhoto!,
                fit: BoxFit.cover,
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Updated Photo ID section to handle tap
  Widget _buildPhotoIdSection() {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showPhotoIdOptions(context); // Call the method to display menu
        },
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _uploadedPhoto != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _uploadedPhoto!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Please upload your current Photo ID',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF156CC9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFF156CC9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDropdownField(String hint, List<String> items) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedPhotoIDType,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedPhotoIDType = newValue;
            });
          },
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ),
    );
  }




  // Helper to build section headers
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            floatingLabelStyle: TextStyle(
              color: Colors.grey.shade700, // Same color as focused border
              fontWeight: FontWeight.bold, // Optional: to highlight focus
            ),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400, // Custom border color when focused
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400, // Default border color when not focused
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF01B4D2), // Background color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Optional for rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            // Save and Close action
          },
          child: const Text('Save and Close',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1448), // Background color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Optional for rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Confirm action
            }
          },
          child: const Text('Confirm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

}
