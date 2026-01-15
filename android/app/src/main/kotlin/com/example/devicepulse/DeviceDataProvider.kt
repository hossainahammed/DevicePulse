class DeviceDataProvider(private val context: Context) {

    fun collect(): Map<String, Any> {
        val intent = context.registerReceiver(
            null,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )!!

        val temp = intent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) / 10.0
        val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, 0)

        val wifi = context.applicationContext
            .getSystemService(Context.WIFI_SERVICE) as WifiManager

        val info = wifi.connectionInfo

        return mapOf(
            "battery" to mapOf(
                "temperature" to temp,
                "level" to level,
                "health" to "Good"
            ),
            "wifi" to mapOf(
                "ssid" to info.ssid,
                "rssi" to info.rssi,
                "ip" to Formatter.formatIpAddress(info.ipAddress)
            ),
            "device" to mapOf(
                "model" to Build.MODEL,
                "android" to Build.VERSION.RELEASE,
                "name" to Build.DEVICE
            )
        )
    }
}
