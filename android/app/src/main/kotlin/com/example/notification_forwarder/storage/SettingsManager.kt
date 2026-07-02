package com.example.notification_forwarder.storage

import android.content.Context

object SettingsManager {

    private const val PREF_NAME = "notification_forwarder"

    private const val BREVO_API_KEY = "brevo_api_key"
    private const val SENDER_NAME = "sender_name"
    private const val SENDER_EMAIL = "sender_email"
    private const val RECIPIENT_EMAIL = "recipient_email"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)

    // -------------------------------
    // Brevo API Key
    // -------------------------------

    fun saveBrevoApiKey(context: Context, apiKey: String) {
        prefs(context)
            .edit()
            .putString(BREVO_API_KEY, apiKey.trim())
            .apply()
    }

    fun getBrevoApiKey(context: Context): String {
        return prefs(context)
            .getString(BREVO_API_KEY, "") ?: ""
    }

    // -------------------------------
    // Sender Name
    // -------------------------------

    fun saveSenderName(context: Context, senderName: String) {
        prefs(context)
            .edit()
            .putString(SENDER_NAME, senderName.trim())
            .apply()
    }

    fun getSenderName(context: Context): String {
        return prefs(context)
            .getString(SENDER_NAME, "") ?: ""
    }

    // -------------------------------
    // Sender Email
    // -------------------------------

    fun saveSenderEmail(context: Context, senderEmail: String) {
        prefs(context)
            .edit()
            .putString(SENDER_EMAIL, senderEmail.trim())
            .apply()
    }

    fun getSenderEmail(context: Context): String {
        return prefs(context)
            .getString(SENDER_EMAIL, "") ?: ""
    }

    // -------------------------------
    // Recipient Email
    // -------------------------------

    fun saveRecipientEmail(context: Context, recipientEmail: String) {
        prefs(context)
            .edit()
            .putString(RECIPIENT_EMAIL, recipientEmail.trim())
            .apply()
    }

    fun getRecipientEmail(context: Context): String {
        return prefs(context)
            .getString(RECIPIENT_EMAIL, "") ?: ""
    }

    // -------------------------------
    // Validation
    // -------------------------------

    fun isConfigured(context: Context): Boolean {

        return getBrevoApiKey(context).isNotBlank() &&
                getSenderName(context).isNotBlank() &&
                getSenderEmail(context).isNotBlank() &&
                getRecipientEmail(context).isNotBlank()
    }

    // -------------------------------
    // Clear Settings (Optional)
    // -------------------------------

    fun clear(context: Context) {
        prefs(context).edit().clear().apply()
    }
}