const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GeoCollectionReference, GeoFirestore, GeoQuery, GeoQuerySnapshot } = require('geofirestore');
admin.initializeApp();

const db = admin.firestore();
const geofirestore = new GeoFirestore(db);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const braintree=require('braintree');

const gateway=new braintree.BraintreeGateway({
    environment:braintree.Environment.Sandbox,
    merchantId:'9bfq8h6gsj46wpmy',
    publicKey:'pjcvfdbfyt7b3274',
    privateKey:'17ce56e01509339f29647a6db7d6d2ab',
});


exports.paypalPayment=functions.https.onRequest(async(req,res)=>{
    
    const nonceFromTheClient=req.body.payment_method_nonce;
    const deviceData=req.body.device_data;
    

    gateway.transaction.sale({
        amount:'10.00',
        paymentMethodNonce:'fake-paypal-one-time-nonce',
        deviceData:deviceData,
        options:{
            submitForSettlement:true
        }

    }, (err,result)=>{
        if(err != null){
            console.log(err);
        }
        else{
            res.json({
                result:'success'
            });
        }
    }

    );
});