package com.example.devicepulse

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "devicepulse/native"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val provider = DeviceDataProvider(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceData") {
                val data = HashMap<String, Any>()
                data.putAll(provider.getBatteryInfo())
                data.putAll(provider.getWifiInfo())
                data.putAll(provider.getDeviceInfo())
                result.success(data)
            } else {
                result.notImplemented()
            }
        }
    }
}


//package com.example.devicepulse
//
//import android.os.Bundle
//import androidx.annotation.NonNull
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
//
//    private val CHANNEL = "devicepulse/native"
//
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        val provider = DeviceDataProvider(this)
//
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            CHANNEL
//        ).setMethodCallHandler { call, result ->
//            when (call.method) {
//                "getDeviceData" -> {
//                    val data = HashMap<String, Any>()
//                    data.putAll(provider.getBatteryInfo())
//                    data.putAll(provider.getWifiInfo())
//                    data.putAll(provider.getDeviceInfo())
//                    result.success(data)
//                }
//                else -> result.notImplemented()
//            }
//        }
//    }
//}


//class MainActivity : FlutterActivity() {
//    private val CHANNEL = "native/device"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        val provider = DeviceDataProvider(this)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                if (call.method == "getDeviceData") {
//                    result.success(provider.collect())
//                }
//            }
//    }
//}
//
