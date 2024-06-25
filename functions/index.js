"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.nuevoMeetup = functions.firestore
    .document("meetups/{id}")
    .onCreate(() => {
    const payload = {
        notification: {
            title: "Nuevo Espacio Startup Space",
            body: "¡Se habre un Nuevo espacio en Startup Space esta semana!",
        },
        topic: "all",
    };
    return admin.messaging().send(payload);
});
//# sourceMappingURL=index.js.map