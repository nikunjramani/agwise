package com.digite.agtech_farmer//package com.digite.agtech_farmer
//
//import io.flutter.app.FlutterApplication
//import io.flutter.plugin.common.PluginRegistry
//
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingPlugin
//
//class Application() : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
//    override fun registerWith(registry: PluginRegistry?) {
//        val key: String? = FlutterFirebaseMessagingPlugin::class.java.canonicalName
//        if (!registry?.hasPlugin(key)!!) {
//            FlutterFirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin"));
//        }
//    }
//}