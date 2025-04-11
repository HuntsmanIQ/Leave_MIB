import 'package:leave_mib/auth/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_mib/auth/loginController.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/LoginScreen.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: GetBuilder<Logincontroller>(
        init: Logincontroller(),
        builder: (controller) => Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ListView(
              children: [
                const SizedBox(height: 410),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 380,
                    width: 398,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.6),
                    ),
                    child: GetBuilder<Auth>(
                      init: Auth(),
                      builder: (auth) => Stack(
                        children: [
                          AbsorbPointer(
                            absorbing: auth.isLoading,
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                Username(controller: usernameController),
                                SizedBox(height: 15),
                                Password(controller: passwordController),
                                SizedBox(height: 10),
                                LoginButton(onTap: () {
                                  auth.startLoading();

                                  auth.signIn(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                                }),
                                SizedBox(height: 10),
                                TextButton(
                                  onPressed: () => auth.showResetPage(context),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 8, 109, 233),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (auth.isLoading) ...[
                            ModalBarrier(
                              dismissible: false,
                              color: Colors.black.withOpacity(0.3),
                            ),
                            Center(child: CircularProgress()),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({super.key, required this.onTap});
  var onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 31, 30, 30),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
      ),
    );
  }
}

class Username extends StatelessWidget {
  Username({super.key, required this.controller});
  final controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: TextField(
          autofocus: true,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          decoration: const InputDecoration(
            label: Text('Email'),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}

class Password extends StatelessWidget {
  Password({super.key, required this.controller});
  final controller;

  final scontroller = Get.put(Logincontroller());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Obx(
          () => TextField(
            controller: controller,
            obscureText: scontroller.isSecure.value,
            decoration: InputDecoration(
              label: Text('Password'),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.security),
              suffixIcon: IconButton(
                onPressed: () {
                  scontroller.isSecure.value = !scontroller.isSecure.value;
                },
                icon: Icon(scontroller.isSecure.value
                    ? Icons.remove_red_eye
                    : Icons.visibility_off),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 50),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text(
            'Please wait...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
