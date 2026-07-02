package com.example.notification_forwarder.listener

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import com.example.notification_forwarder.api.ApiClient
import com.example.notification_forwarder.channel.NotificationStreamHandler
import com.example.notification_forwarder.model.NotificationData
import com.example.notification_forwarder.utils.SelectedAppsManager
import com.example.notification_forwarder.utils.AppNameResolver
import android.content.ComponentName
class NotificationListener : NotificationListenerService() {
override fun onCreate() {
        super.onCreate()
        Log.d("NotificationListener", "SERVICE CREATED")
    }

    override fun onDestroy() {
        Log.d("NotificationListener", "SERVICE DESTROYED")
        super.onDestroy()
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d("NotificationListener", "LISTENER CONNECTED")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()

        Log.d("NotificationListener", "LISTENER DISCONNECTED")

        requestRebind(
            ComponentName(
                this,
                NotificationListener::class.java
            )
        )
    }
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        Log.d("NF", "🔥 onNotificationPosted() fired")
        try {

            val packageName = sbn.packageName
            Log.d("NF", "Package = $packageName")

            // Only forward notifications from selected apps
            if (!SelectedAppsManager.isSelected(this, packageName)) {
                return
            }

            val extras = sbn.notification.extras

            val title = extras.getCharSequence("android.title")?.toString() ?: ""

            val text = extras.getCharSequence("android.text")?.toString() ?: ""

            if (title.isBlank() && text.isBlank()) {
                return
            }

            val notification = NotificationData(
                packageName = packageName,
                title = title,
                text = text,
                postTime = sbn.postTime
            )

            Log.d(
                "NotificationForwarder",
                """
                Package : ${notification.packageName}
                Title   : ${notification.title}
                Text    : ${notification.text}
                """.trimIndent()
            )

            // ==========================
            // Forward directly to backend
            // ==========================
            val appName = AppNameResolver.getAppName(
    this,
    packageName
)

ApiClient.forwardNotification(
    context = this,
    app = appName,
    title = title,
    message = text
)

            // ==========================
            // Update Flutter UI (optional)
            // ==========================
            // NotificationStreamHandler.send(
            //     mapOf(
            //         "packageName" to notification.packageName,
            //         "title" to notification.title,
            //         "text" to notification.text,
            //         "postTime" to notification.postTime
            //     )
            // )

        } catch (e: Exception) {

            Log.e(
                "NotificationForwarder",
                "Notification Error",
                e
            )

        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        super.onNotificationRemoved(sbn)
    }
}