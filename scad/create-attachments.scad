// iRobot Create 2 Deco Cover Screwless Mounting Block
//
// @author Natesh Narain <nnaraindev@gmail.com>
//
include <NopSCADlib/lib.scad>
include <BOSL/constants.scad>
use <BOSL/transforms.scad>

include <vitamins/deco-cover.scad>

use <assemblies/pi-mount.scad>

module main_assembly() {
assembly("main") {
    // The Deco Cover that everything mounts to
    deco_cover();
    // Where the raspberry sits
    translate([deco_mounting_hole_offset_left()[0], deco_mounting_hole_offset_left()[1], deco_thickness()])
        zrot(-90) pi_mount_assembly();
}
}

if ($preview) {
    main_assembly();
}
