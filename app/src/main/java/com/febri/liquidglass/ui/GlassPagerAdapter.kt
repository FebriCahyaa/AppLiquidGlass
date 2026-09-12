package com.febri.liquidglass.ui

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.febri.liquidglass.R

class GlassPagerAdapter(activity: MainActivity) : FragmentStateAdapter(activity) {
    override fun getItemCount(): Int = 4

    override fun createFragment(position: Int): Fragment =
        GlassPageFragment.newInstance(position)
}

class GlassPageFragment : Fragment() {
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View = inflater.inflate(R.layout.fragment_glass_page, container, false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val index = requireArguments().getInt(ARG_INDEX)
        val data = CONTENT[index]
        view.findViewById<TextView>(R.id.pageTitle).text = data.title
        view.findViewById<TextView>(R.id.pageSubtitle).text = data.subtitle
        view.findViewById<TextView>(R.id.cardTitle).text = data.cardTitle
        view.findViewById<TextView>(R.id.cardBody).text = data.cardBody
    }

    companion object {
        private const val ARG_INDEX = "index"

        private data class PageContent(
            val title: String,
            val subtitle: String,
            val cardTitle: String,
            val cardBody: String
        )

        private val CONTENT = listOf(
            PageContent("Discover your flow.", "A calm space for ideas, tasks, and inspiration.", "Beautifully adaptive.", "Translucent surfaces, soft depth, and expressive motion designed for Android."),
            PageContent("Explore new ideas.", "Browse concepts and discover something unexpected.", "A wider perspective.", "A flexible visual language for dashboards, feeds, and creative experiences."),
            PageContent("Your activity.", "Keep track of what matters and see your progress.", "Small steps, real momentum.", "Clear hierarchy and gentle motion help you stay focused without visual noise."),
            PageContent("Make it yours.", "Tune the experience, appearance, and interaction style.", "Personal by design.", "A reusable foundation with light and dark themes, adaptable colors, and native XML layouts.")
        )

        fun newInstance(index: Int) = GlassPageFragment().apply {
            arguments = Bundle().apply { putInt(ARG_INDEX, index) }
        }
    }
}
