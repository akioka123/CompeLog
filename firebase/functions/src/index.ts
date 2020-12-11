// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();

interface Log {
    readonly attempt: number;
    readonly grade: string;
    readonly number: string;
    readonly period: string;
    readonly result: string;
    readonly yearMonth: string;
}

interface RootLog extends Log {
  authorRef?: FirebaseFirestore.DocumentReference;
}

export const onUsersLogCreate = functions.firestore.document('/Logs/{logId}').onCreate(async (snapshot, context) => {
  await copyToRootWithUsersLogSnapshot(snapshot, context);
});
export const onUsersLogUpdate = functions.firestore.document('/Log/{logId}').onUpdate(async (change, context) => {
  await copyToRootWithUsersLogSnapshot(change.after, context);
});


async function copyToRootWithUsersLogSnapshot(snapshot: FirebaseFirestore.DocumentSnapshot, context: functions.EventContext) {
  const logId = snapshot.id;
  const userId = context.params.userId;
  const log = snapshot.data() as RootLog;
  log.authorRef = firestore.collection('User').doc(userId);
  await firestore.collection('Logs').doc(logId).set(log, { merge: true });
}