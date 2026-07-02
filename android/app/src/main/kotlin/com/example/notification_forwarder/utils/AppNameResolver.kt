package com.example.notification_forwarder.utils

import android.content.Context

object AppNameResolver {

    fun getAppName(
        context: Context,
        packageName: String
    ): String {

        return try {

            val pm = context.packageManager

            val appInfo = pm.getApplicationInfo(packageName, 0)

            pm.getApplicationLabel(appInfo).toString()

        } catch (e: Exception) {

            packageName

        }
    }
}