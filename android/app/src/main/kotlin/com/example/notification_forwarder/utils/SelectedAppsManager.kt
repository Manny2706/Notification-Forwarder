package com.example.notification_forwarder.utils

import android.content.Context

object SelectedAppsManager {

    private const val PREF_NAME = "notification_forwarder"
    private const val KEY = "selected_apps"

    fun saveSelectedApps(
        context: Context,
        packages: List<String>
    ) {
        val prefs = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )

        prefs.edit()
            .putStringSet(KEY, packages.toSet())
            .apply()
    }

    fun getSelectedApps(
        context: Context
    ): Set<String> {

        val prefs = context.getSharedPreferences(
            PREF_NAME,
            Context.MODE_PRIVATE
        )

        return prefs.getStringSet(KEY, emptySet()) ?: emptySet()
    }

    fun isSelected(
        context: Context,
        packageName: String
    ): Boolean {
        return getSelectedApps(context).contains(packageName)
    }
}