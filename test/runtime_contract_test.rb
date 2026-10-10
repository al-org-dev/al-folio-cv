# frozen_string_literal: true

require_relative "test_helper"
require "al_folio_cv"

class RuntimeContractTest < Minitest::Test
  def test_render_template_exists
    assert ROOT.join("templates/cv/render.liquid").file?
  end

  def test_assets_are_packaged
    assert ROOT.join("assets/css/al-folio-cv.css").file?
  end

  def test_render_tag_registered
    assert_equal AlFolioCv::RenderTag, Liquid::Template.tags["al_folio_cv_render"]
  end

  def css
    ROOT.join("assets/css/al-folio-cv.css").read
  end

  def test_list_group_is_styled_without_bootstrap_compat
    # al-org-dev/al-folio-cv#8: every CV section is a ul.list-group, but base
    # list-group rules only exist in core's opt-in compat CSS. Without them the
    # starter default (compat off) rendered bullets, a 40px indent and no
    # dividers. These rules mirror compat's values so both modes match.
    assert_includes css, ".cv ul.list-group{margin:0;padding:0;list-style:none}"
    assert_includes css, ".cv ul.list-group>li.list-group-item{padding:.5rem .75rem;border-bottom:1px solid var(--global-divider-color)}"
    assert_includes css, ".cv ul.list-group-flush>li.list-group-item:last-child{border-bottom:0}"
  end

  def test_list_group_rules_do_not_touch_the_div_variant
    # The legacy div.list-group rule sets margin-bottom:2rem; an unscoped
    # `.cv .list-group{margin:0}` would out-rank it and collapse that spacing.
    refute_match(/\.cv \.list-group\{/, css)
  end

  def test_date_table_cells_have_no_top_border
    # al-org-dev/al-folio-cv#9: core gives `table:not(.table) td, th` a top
    # border. Same specificity as the rule below, and this file loads after
    # main.css, so resetting it here is what removes the stray divider drawn
    # above every date badge.
    assert_includes css, "table.table-cv td,table.table-cv th{padding:1px;border-top:0}"
  end
end
