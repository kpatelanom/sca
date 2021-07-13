import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore.document('Users/{userId}'+'msg').onUpdate(async snapshot=>{
    const msg = snapshot.after.data();
    console.log(msg);
    // const querySnapshot = await db.collection('Users').doc()
})
