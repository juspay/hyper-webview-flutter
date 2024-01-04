/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */
package `in`.juspay.hyper_webview_flutter

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.webkit.JavascriptInterface
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.util.Collections

class UPIInterface() {
    companion object {
        fun findApps(activity: Activity, payload: String?): List<Map<String, Any>> {
            val pm = activity.packageManager
            val upiApps = Intent()
            upiApps.data = Uri.parse(payload)
            val resolveInfoList: List<ResolveInfo>
            resolveInfoList = pm.queryIntentActivities(upiApps, 0)
            Collections.sort(resolveInfoList, ResolveInfo.DisplayNameComparator(pm))
            val apps = ArrayList<Map<String, Any>>();
            for (resolveInfo in resolveInfoList) {
                val jsonObject = HashMap<String, Any>();
                try {
                    val ai = pm.getApplicationInfo(resolveInfo.activityInfo.packageName, 0)
                    jsonObject["packageName"] = ai.packageName
                    jsonObject["appName"] = pm.getApplicationLabel(ai)
                    apps.add(jsonObject);
                } catch (ignored: JSONException) {
                } catch (ignored: PackageManager.NameNotFoundException) {
                }
            }
            return apps;
        }

        fun openApp(
            activity: Activity,
            packageName: String?,
            payload: String?,
            action: String?,
            flag: Int
        ) {
            val i = Intent()
            i.setPackage(packageName)
            i.action = action
            i.data = Uri.parse(payload)
            i.flags = flag
            activity.startActivityForResult(i, Constants.OPENAPPS_REQUEST_CODE)
        }

        fun getResourceByName(activity: Activity, resName: String?): String {
            return getResourceById(
                activity,
                activity.resources.getIdentifier(
                    resName,
                    "string",
                    activity.packageName
                )
            )
        }

        private fun getResourceById(activity: Activity, resId: Int): String {
            return activity.resources.getString(resId)
        }
    }
}
