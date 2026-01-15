class MainActivity : FlutterActivity() {
    private val CHANNEL = "native/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val provider = DeviceDataProvider(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getDeviceData") {
                    result.success(provider.collect())
                }
            }
    }
}

