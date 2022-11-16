import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_paypal_integration/firebase_options.dart';
import 'package:flutter_paypal_integration/shared/strings.dart';
import 'package:http/http.dart' as http ;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var url ='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final request = BraintreeDropInRequest(
                clientToken: token,
                collectDeviceData: true,
                cardEnabled:true,
                paypalRequest: BraintreePayPalRequest(
                  amount: '4.20',
                  displayName: 'Mohamed Ehap',
                ),
              );
              BraintreeDropInResult? result =
                  await BraintreeDropIn.start(request);

              if (result != null) {
              showNonce(result.paymentMethodNonce);
              
              final http.Response response=await http.post(Uri.parse(
                '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}',
              ));

              final payResult=jsonDecode(response.body);
              if(payResult['result']=='success') print('payment done');
                            } 
            },
            child: const Text(
              'Pay',
            ),
          ),
        ));
  }

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }
}
