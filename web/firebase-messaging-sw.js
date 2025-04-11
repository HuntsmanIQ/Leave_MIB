importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.0.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyDmLZgWnltinSOZFN8TNe3MhGLJWgwqaO0",
  authDomain: "leave-mib.firebaseapp.com",
  projectId: "leave-mib",
  storageBucket: "leave-mib.appspot.com",
  messagingSenderId: "112530840436",
  appId: "1:112530840436:web:502fd0634a4d9b12b9aa21"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Received background message ", payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/firebase-logo.png",
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
