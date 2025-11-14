import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.verifyEmailText,
    required this.verifyOTPText,
  });

  final String verifyEmailText;
  final String verifyOTPText;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool _loginInProgress = false;
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 82),
                  Text(
                    'Reset Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Password should be more than 6 letters and combination of numbers',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'New Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(
                      hintText: 'Confirm New Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _onTapResetPasswordButton,
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                  const SizedBox(height: 36),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        text: "Already have an account? ",
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignUpButton,
                          ),
                        ],
                      ),
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

  void _onTapSignUpButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (predicate) => false,
    );
  }

  void _onTapResetPasswordButton() {
    // Login Button Function
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  // Api Calling for Login Request ================ //

  Future<void> _login() async {
    // API Called
    _loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email":widget.verifyEmailText,
      "OTP": widget.verifyOTPText,
      "password": _passwordTEController.text,

    }; // Prepare Body

    // postRequest is main a ApiResponse type method
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.resetPassUrl, // Url in Utils -> This is loginApiURl
      body: requestBody,
    );
    if (response.isSuccess && response.responseData['status'] == 'success') {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (predicate) => false,
      );
    } else {
      _loginInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
