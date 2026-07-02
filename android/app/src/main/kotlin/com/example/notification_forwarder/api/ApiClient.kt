package com.example.notification_forwarder.api

import android.content.Context
import android.util.Log
import com.example.notification_forwarder.storage.SettingsManager
import okhttp3.Call
import okhttp3.Callback
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import org.json.JSONArray
import org.json.JSONObject
import java.io.IOException
import java.util.concurrent.TimeUnit

object ApiClient {

    private const val TAG = "ApiClient"

    private const val BREVO_URL =
        "https://api.brevo.com/v3/smtp/email"

    private val client = OkHttpClient.Builder()
        .connectTimeout(15, TimeUnit.SECONDS)
        .readTimeout(15, TimeUnit.SECONDS)
        .writeTimeout(15, TimeUnit.SECONDS)
        .build()

    fun forwardNotification(
        context: Context,
        app: String,
        title: String,
        message: String
    ) {

        if (!SettingsManager.isConfigured(context)) {
            Log.e(TAG, "Brevo settings not configured.")
            return
        }

        val apiKey = SettingsManager.getBrevoApiKey(context)
        val senderName = SettingsManager.getSenderName(context)
        val senderEmail = SettingsManager.getSenderEmail(context)
        val recipientEmail = SettingsManager.getRecipientEmail(context)

        val htmlContent = """
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>

body{
font-family:Arial,Helvetica,sans-serif;
background:#f5f5f5;
padding:30px;
}

.card{
background:white;
border-radius:10px;
padding:24px;
max-width:650px;
margin:auto;
box-shadow:0 2px 10px rgba(0,0,0,.1);
}

table{
width:100%;
border-collapse:collapse;
}

td{
padding:12px;
border:1px solid #ddd;
}

h2{
color:#2563eb;
}

</style>
</head>

<body>

<div class="card">

<h2>📲 Notification Forwarded</h2>

<p>Your Android device forwarded the following notification.</p>

<table>

<tr>
<td><b>Application</b></td>
<td>$app</td>
</tr>

<tr>
<td><b>Title</b></td>
<td>$title</td>
</tr>

<tr>
<td><b>Message</b></td>
<td>$message</td>
</tr>

</table>

<br>

<p style="color:gray;font-size:13px">
Generated automatically by PitWatch Notification Forwarder.
</p>

</div>

</body>
</html>
        """.trimIndent()

        val payload = JSONObject().apply {

            put(
                "sender",
                JSONObject().apply {
                    put("name", senderName)
                    put("email", senderEmail)
                }
            )

            put(
                "to",
                JSONArray().put(
                    JSONObject().apply {
                        put("email", recipientEmail)
                    }
                )
            )

            put(
                "subject",
                "📲 $app Notification"
            )

            put(
                "htmlContent",
                htmlContent
            )
        }

        val body = payload.toString()
            .toRequestBody("application/json".toMediaType())

        val request = Request.Builder()
            .url(BREVO_URL)
            .addHeader("accept", "application/json")
            .addHeader("content-type", "application/json")
            .addHeader("api-key", apiKey)
            .post(body)
            .build()

        client.newCall(request).enqueue(object : Callback {

            override fun onFailure(call: Call, e: IOException) {
                Log.e(TAG, "Brevo request failed", e)
            }

            override fun onResponse(call: Call, response: Response) {

                response.use {

                    val responseBody = it.body?.string()

                    if (it.isSuccessful) {

                        Log.d(TAG, "Email sent successfully.")
                        Log.d(TAG, responseBody ?: "")

                    } else {

                        Log.e(
                            TAG,
                            "Brevo Error ${it.code}\n$responseBody"
                        )

                    }
                }
            }
        })
    }
}