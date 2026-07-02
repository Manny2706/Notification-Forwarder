package com.example.notification_forwarder.apps

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log

object InstalledAppsProvider {

    fun getInstalledApps(context: Context): List<Map<String, String>> {

        val pm = context.packageManager

        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }

        val resolveInfos = pm.queryIntentActivities(intent, PackageManager.MATCH_ALL)

        val apps = mutableListOf<Map<String, String>>()
        val seenPackages = mutableSetOf<String>()

        for (resolveInfo in resolveInfos) {

            val packageName = resolveInfo.activityInfo.packageName

            if (!seenPackages.add(packageName)) {
                continue
            }

            val appName = resolveInfo.loadLabel(pm).toString()

            Log.d(
                "InstalledApps",
                "$appName -> $packageName"
            )

            apps.add(
                mapOf(
                    "name" to appName,
                    "package" to packageName
                )
            )
        }

        apps.sortBy { it["name"]?.lowercase() }

        return apps
    }
}