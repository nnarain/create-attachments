// iRobot Create 2 Deco Cover Screwless Mounting Block
//
// @author Natesh Narain <nnaraindev@gmail.com>
//
include <NopSCADlib/lib.scad>

include <vitamins/deco-cover.scad>

include <parts/blocks-spec.scad>
use <parts/block.scad>

use <parts/pi-mount.scad>

module main_assembly() {
assembly("main") {
    // The Deco Cover that everything mounts to
    deco_cover();
    // Left block
    translate([deco_mounting_hole_offset_left()[0], deco_mounting_hole_offset_left()[1], deco_thickness()])
        left_block_assembly();
    // Right block
    translate([deco_mounting_hole_offset_right()[0], deco_mounting_hole_offset_right()[1], deco_thickness()])
        right_block_assembly();
    // Mount of the PI
    translate([0, deco_mounting_hole_offset_right()[1] + 10, deco_thickness()])
        rotate([0, 0, -90])
            pi_mount_assembly();
}
}

if ($preview) {
    main_assembly();
}
