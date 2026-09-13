package com.febri.liquidglass.ui

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Analytics
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Search
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.Icon
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.material.icons.filled.Assessment

private val Violet = Color(0xFF6C5CE7)
private val Cyan = Color(0xFF00B8B5)
private val Background = Color(0xFFF2F2F8)
private val DarkBackground = Color(0xFF101018)

data class GlassDestination(
    val title: String,
    val subtitle: String,
    val cardTitle: String,
    val cardBody: String
)

private val destinations = listOf(
    GlassDestination("Discover your flow.", "A calm space for ideas, tasks, and inspiration.",
        "Beautifully adaptive.", "Translucent surfaces, soft depth, and expressive motion designed for Android."),
    GlassDestination("Explore new ideas.", "Browse concepts and discover something unexpected.",
        "A wider perspective.", "A flexible visual language for dashboards, feeds, and creative experiences."),
    GlassDestination("Your activity.", "Keep track of what matters and see your progress.",
        "Small steps, real momentum.", "Clear hierarchy and gentle motion help you stay focused without visual noise."),
    GlassDestination("Make it yours.", "Tune the experience, appearance, and interaction style.",
        "Personal by design.", "A reusable foundation with light and dark themes, adaptable colors, and native gestures.")
)

class LiquidGlassComposeActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent { LiquidGlassApp() }
    }
}

@Composable
fun LiquidGlassApp() {
    var selected by remember { mutableIntStateOf(0) }
    val configuration = LocalConfiguration.current
    val isDark = configuration.uiMode and 0x30 == 0x20
    val background = if (isDark) DarkBackground else Background

    Surface(modifier = Modifier.fillMaxSize(), color = background) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp, vertical = 24.dp)
                .navigationBarsPadding()
        ) {
            Text(
                text = "Good morning",
                color = if (isDark) Color(0xFFAAAABD) else Color(0xFF737384),
                fontSize = 15.sp
            )
            Spacer(Modifier.height(8.dp))
            Box(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .pointerInput(Unit) {
                        detectHorizontalDragGestures(
                            onDragEnd = {},
                            onHorizontalDrag = { _, amount ->
                                if (amount < -35f) selected = (selected + 1).coerceAtMost(3)
                                if (amount > 35f) selected = (selected - 1).coerceAtLeast(0)
                            }
                        )
                    }
            ) {
                AnimatedContent(
                    targetState = selected,
                    transitionSpec = { fadeIn() togetherWith fadeOut() },
                    label = "glass-page"
                ) { index ->
                    GlassPage(destinations[index], isDark)
                }
            }
            GlassNavigation(selected = selected, onSelected = { selected = it }, isDark = isDark)
        }
    }
}

@Composable
private fun GlassPage(destination: GlassDestination, isDark: Boolean) {
    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            destination.title,
            color = if (isDark) Color.White else Color(0xFF171722),
            fontSize = 32.sp,
            fontWeight = FontWeight.Bold,
            lineHeight = 38.sp
        )
        Spacer(Modifier.height(8.dp))
        Text(
            destination.subtitle,
            color = if (isDark) Color(0xFFAAAABD) else Color(0xFF737384),
            fontSize = 15.sp
        )
        Spacer(Modifier.height(28.dp))
        GlassCard(destination, isDark)
    }
}

@Composable
private fun GlassCard(destination: GlassDestination, isDark: Boolean) {
    val surface = if (isDark) Color.White.copy(alpha = .10f) else Color.White.copy(alpha = .72f)
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(28.dp))
            .background(
                Brush.linearGradient(
                    listOf(surface, surface.copy(alpha = .40f))
                )
            )
            .padding(24.dp)
    ) {
        Text(
            "LIQUID GLASS SYSTEM",
            color = if (isDark) Color(0xFFA79BFF) else Violet,
            fontSize = 12.sp,
            fontWeight = FontWeight.Bold
        )
        Spacer(Modifier.height(10.dp))
        Text(
            destination.cardTitle,
            color = if (isDark) Color.White else Color(0xFF171722),
            fontSize = 24.sp,
            fontWeight = FontWeight.Bold
        )
        Spacer(Modifier.height(8.dp))
        Text(
            destination.cardBody,
            color = if (isDark) Color(0xFFAAAABD) else Color(0xFF737384),
            fontSize = 15.sp
        )
    }
}

@Composable
private fun GlassNavigation(selected: Int, onSelected: (Int) -> Unit, isDark: Boolean) {
    val labels = listOf("Home", "Explore", "Activity", "Settings")
    val icons = listOf(Icons.Outlined.Home, Icons.Outlined.Search, Icons.Outlined.Analytics, Icons.Outlined.Settings)
    val navColor = if (isDark) Color(0x331F1F2C) else Color.White.copy(alpha = .80f)

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(36.dp))
            .background(navColor)
            .padding(6.dp),
        horizontalArrangement = Arrangement.SpaceEvenly
    ) {
        labels.forEachIndexed { index, label ->
            val active = index == selected
            val alpha by animateFloatAsState(if (active) 1f else .65f, label = "nav-alpha")
            Surface(
                onClick = { onSelected(index) },
                modifier = Modifier.weight(1f),
                shape = RoundedCornerShape(24.dp),
                color = if (active) Violet else Color.Transparent
            ) {
                Column(
                    modifier = Modifier.padding(vertical = 10.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        icons[index],
                        contentDescription = label,
                        modifier = Modifier.size(24.dp).alpha(alpha),
                        tint = if (active) Color.White else if (isDark) Color.White else Color(0xFF737384)
                    )
                    Spacer(Modifier.height(2.dp))
                    Text(
                        label,
                        color = if (active) Color.White else if (isDark) Color.White else Color(0xFF737384),
                        fontSize = 11.sp
                    )
                }
            }
        }
    }
}
