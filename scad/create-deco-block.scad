// iRobot Create 2 Deco Cover Screwless Mounting Block
//
// @author Natesh Narain <nnaraindev@gmail.com>
//
include <NopSCADlib/lib.scad>

include <vitamins/deco-cover.scad>

include <parts/blocks-spec.scad>
use <parts/block.scad>

module main_assembly() {
assembly("main") {
    deco_cover();
    translate([deco_mounting_hole_offset_left()[0], deco_mounting_hole_offset_left()[1], -underside_thickness()])
        left_block_assembly();
    translate([deco_mounting_hole_offset_right()[0], deco_mounting_hole_offset_right()[1], -underside_thickness()])
        right_block_assembly();
}
}

if ($preview) {
    main_assembly();
}
