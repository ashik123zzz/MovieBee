import 'package:dartz/dartz.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviebee/application/auth/bloc/auth_bloc.dart';
import 'package:moviebee/application/auth/signin_form/signin_form_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:moviebee/presentation/core/contants.dart';
import 'package:moviebee/presentation/routes/router.gr.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninFormBloc, SigninFormState>(
        listener: (context, state) {
      state.authFailureOrSuccessOption!.fold(
        () {},
        (either) => either.fold((failure) {
          final String bar = failure.maybeMap(
            serverError: (_) => 'Server Error',
            invalidEmailAndPasswordCombination: (_) =>
                'Invalid Email and Password combination',
            orElse: () => 'Error ! Contact the developer',
          );
          showFlash(
              context: context,
              duration: const Duration(seconds: 4),
              builder: (context, controller) {
                return Flash.bar(
                  controller: controller,
                  backgroundColor: kPrimaryColor.withAlpha(50),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Container(
                      height: 35,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Icon(Icons.dangerous, color: kPrimaryColor),
                          const SizedBox(width: 8),
                          Text(
                            bar,
                            style: const TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }, (_) {
          context.router.replace(const HomePageRoute());
          context.bloc<AuthBloc>().add(const AuthEvent.authCheckRequested());
        }),
      );
    }, builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(13.0),
        child: Form(
          autovalidateMode: state.showErrorMessages,
          child: ListView(
            children: [
              const SizedBox(height: 160),
              Center(
                child: Text(
                  'MB',
                  style: GoogleFonts.pacifico(
                    color: kPrimaryColor,
                    fontSize: 45,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kPrimaryColor.withAlpha(50),
                ),
                child: TextFormField(
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(
                        Icons.email,
                        color: kPrimaryColor,
                      ),
                    ),
                    hintText: 'Email',
                    border: InputBorder.none,
                  ),
                  autocorrect: false,
                  onChanged: (value) => context.bloc<SigninFormBloc>().add(
                        SigninFormEvent.emailChanged(value),
                      ),
                  validator: (_) => context
                      .bloc<SigninFormBloc>()
                      .state
                      .emailAddress!
                      .value
                      .fold(
                        (f) => f.maybeMap(
                          invalidEmail: (_) => 'Invalid Email',
                          orElse: () => null,
                        ),
                        (_) => null,
                      ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kPrimaryColor.withAlpha(50),
                ),
                child: TextFormField(
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                    ),
                    hintText: 'Password',
                    border: InputBorder.none,
                  ),
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) => context.bloc<SigninFormBloc>().add(
                        SigninFormEvent.passwordChanged(value),
                      ),
                  validator: (_) =>
                      context.bloc<SigninFormBloc>().state.password!.value.fold(
                            (f) => f.maybeMap(
                              shortPassword: (_) => 'Short Password',
                              orElse: () => null,
                            ),
                            (_) => null,
                          ),
                ),
              ),
              const SizedBox(height: 15),
              Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.bloc<SigninFormBloc>().add(
                              const SigninFormEvent
                                  .signInWithEmailAndPasswordPressed());
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: kPrimaryColor)))),
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.router.push(const SignUpPageRoute());
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: kPrimaryColor)))),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.router.push(const GetOtpPageRoute());
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: kPrimaryColor, fontSize: 18),
                  ),
                ),
              ]),
              if (state.isSubmitting!) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: null,
                  backgroundColor: kPrimaryColor.withAlpha(50),
                  color: kPrimaryColor,
                ),
              ]
            ],
          ),
        ),
      );
    });
  }
}
