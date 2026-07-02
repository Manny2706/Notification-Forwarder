package com.example.notification_forwarder.utils

object Constants {

    const val EVENT_CHANNEL = "notification_forwarder/events"

    val ALLOWED_APPS  = setOf(

        // Google Pay
        "com.google.android.apps.nbu.paisa.user",

        // PhonePe
        "com.phonepe.app",

        // Paytm
        "net.one97.paytm",

        // BHIM
        "in.org.npci.upiapp",

        // WhatsApp
        "com.whatsapp",

        // WhatsApp Business
        "com.whatsapp.w4b",

        // Google Messages
        "com.google.android.apps.messaging",

        // Default Android SMS
        "com.android.messaging",

        // Gmail
        "com.google.android.gm"

    )
}