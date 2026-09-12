plugins { id("com.android.application"); id("org.jetbrains.kotlin.android") }

android { namespace = "com.febri.liquidglass"; compileSdk = 37
    defaultConfig { applicationId = "com.febri.liquidglass"; minSdk = 26; targetSdk = 37; versionCode = 1; versionName = "1.0" }
}

kotlin { jvmToolchain(17) }

dependencies {
    implementation("androidx.core:core-ktx:1.15.0")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
}
