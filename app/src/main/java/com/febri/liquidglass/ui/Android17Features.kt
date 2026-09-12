package com.febri.liquidglass.ui

import android.os.Build
import android.view.Window
import androidx.core.view.WindowCompat

/** Small compatibility layer: newer Android features are opt-in and safely fall back. */
object Android17Features {
    fun configureWindow(window: Window) {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        if (Build.VERSION.SDK_INT >= 35) {
            // Edge-to-edge is enforced on newer Android releases; this keeps the
            // template correct on Android 15+ and future Android 17 devices.
            window.isNavigationBarContrastEnforced = false
            window.isStatusBarContrastEnforced = false
        }
    }

    fun supportsModernBack(): Boolean = Build.VERSION.SDK_INT >= 33
    fun supportsBlur(): Boolean = Build.VERSION.SDK_INT >= 31
}
