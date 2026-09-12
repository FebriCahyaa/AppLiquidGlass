package com.febri.liquidglass.ui

import android.animation.ArgbEvaluator
import android.animation.ObjectAnimator
import android.os.Bundle
import android.view.View
import android.view.animation.PathInterpolator
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.viewpager2.widget.ViewPager2
import com.febri.liquidglass.R
import kotlin.math.roundToInt

class MainActivity : AppCompatActivity() {
    private lateinit var pager: ViewPager2
    private lateinit var navPill: View
    private lateinit var tabs: List<LinearLayout>
    private lateinit var icons: List<ImageView>
    private lateinit var labels: List<TextView>

    private val accent = 0xFF6C5CE7.toInt()
    private val inactive = 0xFF777783.toInt()
    private val titles = listOf("Home", "Explore", "Activity", "Settings")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Android17Features.configureWindow(window)
        setContentView(R.layout.activity_main)

        pager = findViewById(R.id.pager)
        navPill = findViewById(R.id.navPill)
        tabs = listOf(R.id.tabHome, R.id.tabExplore, R.id.tabActivity, R.id.tabSettings)
            .map(::findViewById)
        icons = listOf(R.id.homeTabIcon, R.id.exploreTabIcon, R.id.activityTabIcon, R.id.settingsTabIcon).map(::findViewById)
        labels = listOf(R.id.homeTabLabel, R.id.exploreTabLabel, R.id.activityTabLabel, R.id.settingsTabLabel).map(::findViewById)

        pager.adapter = GlassPagerAdapter(this)
        pager.offscreenPageLimit = 4
        pager.setPageTransformer(GlassPageTransformer())

        tabs.forEachIndexed { index, tab ->
            tab.setOnClickListener {
                pager.setCurrentItem(index, true)
            }
        }

        pager.registerOnPageChangeCallback(object : ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                updateTabColors(position)
            }

            override fun onPageScrolled(position: Int, positionOffset: Float, positionOffsetPixels: Int) {
                movePill(position, positionOffset)
            }
        })

        pager.post {
            updateTabColors(0)
            movePill(0, 0f)
        }
    }

    private fun updateTabColors(index: Int) {
        icons.forEachIndexed { i, icon ->
            val selected = i == index
            icon.alpha = if (selected) 1f else .68f
            labels[i].setTextColor(if (selected) 0xFFFFFFFF.toInt() else inactive)
            tabs[i].animate()
                .scaleX(if (selected) 1f else .96f)
                .scaleY(if (selected) 1f else .96f)
                .setDuration(180)
                .start()
        }
    }

    private fun movePill(position: Int, offset: Float) {
        if (tabs.isEmpty()) return
        val from = position.coerceIn(0, tabs.lastIndex)
        val direction = if (offset >= 0f) 1 else -1
        val to = (from + direction).coerceIn(0, tabs.lastIndex)
        val start = tabs[from]
        val end = tabs[to]
        if (start.width == 0 || end.width == 0) return

        val x = start.left + (end.left - start.left) * offset + 6f
        val width = start.width + ((end.width - start.width) * offset).roundToInt()
        navPill.layoutParams = navPill.layoutParams.apply { this.width = width }
        navPill.translationX = x.toFloat()
    }

    private class GlassPageTransformer : ViewPager2.PageTransformer {
        override fun transformPage(page: View, position: Float) {
            val abs = kotlin.math.abs(position)
            page.alpha = (1f - abs * .35f).coerceIn(.65f, 1f)
            page.translationX = -position * page.width * .08f
            page.scaleY = 1f - abs * .035f
        }
    }
}
