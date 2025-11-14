import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  bool _loginInProgress = false;
  final TextEditingController _emailTEController = TextEditingController();
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
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A 6 digits OTP will be sent to your email address',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if (EmailValidator.validate(inputText) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _loginInProgress == false,
                    replacement: CenteredProgressIndicator(),
                    child: FilledButton(
                      onPressed: _onTapNextButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
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
                              ..onTap = _onTapLoginButton,
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

  void _onTapLoginButton() {
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _verifyEmail();
    }
  }

  Future<void> _verifyEmail() async {
    // API Called
    _loginInProgress = true;
    setState(() {});

    String url = Urls.verifyEmailUrl(_emailTEController.text.trim());

    // postRequest is main a ApiResponse type method
    final ApiResponse response = await ApiCaller.getRequest(url: url);
    if (response.isSuccess && response.responseData['status'] == 'success') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordVerifyOtpScreen(emailVerify: _emailTEController.text.trim(),),
        ),
      );
    } else {
      _loginInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
