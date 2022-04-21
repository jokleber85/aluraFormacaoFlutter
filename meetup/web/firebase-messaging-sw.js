importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

var firebaseConfig = {
    chaves : 'chaves que estão no link abaixo',
    link: 'https://github.com/firebase/flutterfire/tree/master/packages/firebase_messaging/firebase_messaging/example/web'
  };
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});