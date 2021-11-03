import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:moviebee/application/auth/signin_form/signin_form_bloc.dart';
import 'package:moviebee/injection.dart';
import 'package:moviebee/presentation/core/contants.dart';
import 'package:moviebee/presentation/movie/booking_sections/seat_selection_page.dart';
import 'package:moviebee/presentation/routes/router.gr.dart';

class TopUpWalletPage extends StatelessWidget {
  final String? balance;
  const TopUpWalletPage({
    Key? key,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
        ),
        body: BlocProvider(
          create: (context) => getIt<SigninFormBloc>(),
          child: BlocConsumer<SigninFormBloc, SigninFormState>(
              listener: (context, state) {
            state.authFailureOrSuccessOption!.fold(
              () {},
              (either) => either.fold((failure) {
                final String bar = failure.maybeMap(
                  serverError: (value) => "Server Error",
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
                                const Icon(Icons.dangerous,
                                    color: kPrimaryColor),
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
                //context.router.replace(const VerifyOtpPageRoute());
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
                                const Icon(Icons.check, color: kPrimaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Amount added successfully',
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
                context.router.replace(const HomePageRoute());
              }),
            );
          }, builder: (context, state) {
            return Container(
              color: kPrimaryColor.withAlpha(50),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Form(
                  autovalidateMode: state.showErrorMessages,
                  child: ListView(
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        'Add Amount',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.pacifico(
                          color: kPrimaryColor,
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPrimaryColor.withAlpha(50),
                        ),
                        child: TextFormField(
                          cursorColor: kPrimaryColor,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            // ignore: unnecessary_raw_strings
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Icon(
                                Icons.email,
                                color: kPrimaryColor,
                              ),
                            ),
                            hintText: 'Enter Amount',
                            border: InputBorder.none,
                          ),
                          autocorrect: false,
                          onChanged: (value) =>
                              context.bloc<SigninFormBloc>().add(
                                    SigninFormEvent.amountChanged(value),
                                  ),
                          validator: (_) => context
                              .bloc<SigninFormBloc>()
                              .state
                              .amount!
                              .value
                              .fold(
                                (f) => f.maybeMap(
                                  emptyCredential: (_) =>
                                      'Amount cannot be empty!',
                                  invalidAmount: (_) =>
                                      'Amount cannot be zero!',
                                  orElse: () => null,
                                ),
                                (_) => null,
                              ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.bloc<SigninFormBloc>().add(
                                    SigninFormEvent.addWalletAmountPressed(
                                        balance));
                                personMovieList = [];
                                seatListFinal = '';
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(kPrimaryColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: kPrimaryColor)))),
                              child: const Text(
                                'Add Amount',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ),
            );
          }),
        ));
  }
}
