package com.febri.liquidglass.ui

import android.animation.ArgbEvaluator
import android.animation.ObjectAnimator
import android.content.res.Configuration
import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.view.Window
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.WindowCompat
import com.febri.liquidglass.R

class MainActivity : AppCompatActivity() {
    private lateinit var title: TextView
    private lateinit var subtitle: TextView
    private lateinit var cardTitle: TextView
    private lateinit var cardBody: TextView
    private lateinit var tabs: List<LinearLayout>
    private lateinit var navPill: View

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Android17Features.configureWindow(window)
        setContentView(R.layout.activity_main)
        title = findViewById(R.id.title)
        subtitle = findViewById(R.id.subtitle)
        cardTitle = findViewById(R.id.cardTitle)
        cardBody = findViewById(R.id.cardBody)
        navPill = findViewById(R.id.navPill)
        tabs = listOf(R.id.tabHome, R.id.tabExplore, R.id.tabActivity, R.id.tabSettings).map { findViewById(it) }
        tabs.forEachIndexed { index, tab -> tab.setOnClickListener { selectTab(index) } }
        selectTab(0)
    }

    private fun selectTab(index: Int) {
        val content = listOf(
            Triple("Discover your flow.", "A calm space for ideas, tasks, and inspiration.", "Beautifully adaptive."),
            Triple("Explore new ideas.", "Browse concepts and discover something unexpected.", "A wider perspective."),
            Triple("Your activity.", "Keep track of what matters and see your progress.", "Small steps, real momentum."),
            Triple("Make it yours.", "Tune the experience, appearance, and interaction style.", "Personal by design.")
        )[index]
        title.text = content.first
        subtitle.text = content.second
        cardTitle.text = content.third
        cardBody.text = when (index) {
            0 -> "Translucent surfaces, soft depth, and expressive motion designed for Android."
            1 -> "A flexible visual language for dashboards, feeds, and creative experiences."
            2 -> "Clear hierarchy and gentle motion help you stay focused without visual noise."
            else -> "A reusable foundation with light and dark themes, adaptable colors, and native XML layouts."
        }
        tabs.forEachIndexed { i, tab ->
            tab.setBackgroundColor(Color.TRANSPARENT)
            tab.alpha = if (i == index) 1f else .66f
            tab.animate().scaleX(if (i == index) 1f else .96f).scaleY(if (i == index) 1f else .96f).setDuration(220).start()
        }
        navPill.post {
            val target = tabs[index]
            val lp = navPill.layoutParams
            lp.width = target.width
            navPill.layoutParams = lp
            navPill.animate().x(target.left.toFloat()).setDuration(360).setInterpolator(android.view.animation.PathInterpolator(.2f, .8f, .2f, 1f)).start()
        }
    }
}
