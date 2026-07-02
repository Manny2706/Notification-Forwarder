package com.example.notification_forwarder
import com.example.notification_forwarder.storage.SettingsManager
import com.example.notification_forwarder.channel.NotificationStreamHandler
import com.example.notification_forwarder.permission.PermissionHelper
import com.example.notification_forwarder.utils.Constants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import com.example.notification_forwarder.apps.InstalledAppsProvider
import com.example.notification_forwarder.utils.SelectedAppsManager
class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "notification_forwarder/methods"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            Constants.EVENT_CHANNEL
        ).setStreamHandler(object : EventChannel.StreamHandler {

            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                NotificationStreamHandler.eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                NotificationStreamHandler.eventSink = null
            }

        })
        
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "openNotificationSettings" -> {
                    PermissionHelper.openNotificationSettings(this)
                }
                "isNotificationAccessEnabled" -> {
    result.success(
        PermissionHelper.isNotificationAccessEnabled(this)
    )
}
"getInstalledApps" -> {
    result.success(
        InstalledAppsProvider.getInstalledApps(this)
    )
}
"saveSelectedApps" -> {

    val packages =
        call.arguments as? List<*> ?: emptyList<Any>()

    SelectedAppsManager.saveSelectedApps(
        this,
        packages.filterIsInstance<String>()
    )

    result.success(true)
}
"getSelectedApps" -> {
    result.success(
        SelectedAppsManager
            .getSelectedApps(this)
            .toList()
    )

}
"saveBrevoApiKey" -> {

    val apiKey = call.argument<String>("apiKey") ?: ""

    SettingsManager.saveBrevoApiKey(this, apiKey)

    result.success(true)
}

"getBrevoApiKey" -> {

    result.success(
        SettingsManager.getBrevoApiKey(this)
    )
}

"saveSenderName" -> {

    val senderName = call.argument<String>("senderName") ?: ""

    SettingsManager.saveSenderName(this, senderName)

    result.success(true)
}

"getSenderName" -> {

    result.success(
        SettingsManager.getSenderName(this)
    )
}

"saveSenderEmail" -> {

    val senderEmail = call.argument<String>("senderEmail") ?: ""

    SettingsManager.saveSenderEmail(this, senderEmail)

    result.success(true)
}

"getSenderEmail" -> {

    result.success(
        SettingsManager.getSenderEmail(this)
    )
}

"saveRecipientEmail" -> {

    val recipientEmail = call.argument<String>("recipientEmail") ?: ""

    SettingsManager.saveRecipientEmail(this, recipientEmail)

    result.success(true)
}

"getRecipientEmail" -> {

    result.success(
        SettingsManager.getRecipientEmail(this)
    )
}
"requestIgnoreBatteryOptimization" -> {
    PermissionHelper.requestIgnoreBatteryOptimization(this)
    result.success(true)
}

"isIgnoringBatteryOptimization" -> {
    result.success(
        PermissionHelper.isIgnoringBatteryOptimizations(this)
    )
}
                else -> result.notImplemented()
            }
            
        }
    }
    
}