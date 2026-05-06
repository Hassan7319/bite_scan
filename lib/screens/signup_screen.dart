import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bite_scan/routes.dart';
import 'package:bite_scan/user_manager.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();
  
  String _selectedGender = 'Male';
  bool _agreeToPolicy = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00B894),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1A233A),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final dob = _dobController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (!_agreeToPolicy) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to the privacy policy')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await UserManager.register(
        name: name,
        email: email,
        password: password,
        dob: dob,
        gender: _selectedGender,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup successful! Please login.')));
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A233A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.15,
                      width: double.infinity,
                      color: const Color(0xFF1A233A),
                      child: const Center(
                        child: Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField('Full Name', _nameController, Icons.person_outline),
                            const SizedBox(height: 16),
                            _buildTextField('Email', _emailController, Icons.email_outlined),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Date of Birth', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: _dobController,
                                        readOnly: true,
                                        onTap: _selectDate,
                                        decoration: InputDecoration(
                                          hintText: 'Select date',
                                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Gender', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                                      const SizedBox(height: 8),
                                      DropdownButtonFormField<String>(
                                        value: _selectedGender,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                        ),
                                        items: ['Male', 'Female', 'Other'].map((String value) {
                                          return DropdownMenuItem<String>(value: value, child: Text(value));
                                        }).toList(),
                                        onChanged: (newValue) => setState(() => _selectedGender = newValue!),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField('Password', _passwordController, Icons.lock_outline, obscure: true),
                            const SizedBox(height: 16),
                            _buildTextField('Confirm Password', _confirmPasswordController, Icons.lock_reset_outlined, obscure: true),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: _agreeToPolicy,
                                  activeColor: const Color(0xFF00B894),
                                  onChanged: (value) => setState(() => _agreeToPolicy = value!),
                                ),
                                const Expanded(
                                  child: Text(
                                    'I have read and I agree to the Privacy Policy',
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00B894),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(color: Colors.black54),
                                    children: [
                                      TextSpan(text: 'Login', style: TextStyle(color: Color(0xFF00B894), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Enter your ${label.toLowerCase()}',
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
      ],
    );
  }
}
