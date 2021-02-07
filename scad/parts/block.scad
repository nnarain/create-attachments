include <NopSCADlib/core.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>
use <BOSL/sliders.scad>

// Two pieces.
// The underside, which has columns that come through the cover mounting holes
// The fastener side that mates with the columns. The fastener will have inserts for 
// machine screws
include <../vitamins/deco-cover-spec.scad>
include <./blocks-spec.scad>

padding = 10;
hole_group_length_x = deco_mounting_holes_length_x();
// The block will be large enough to cover the mounting holes
underside_length = hole_group_length_x + padding;
underside_width = deco_mounting_holes_length_y() + padding;
underside_thickness = 2;

// How long the columns must be
column_height = 15;

fastener_mounting_hole_depth = 10;
fastener_mounting_cutaway = 10;

bind = 0.01;

module columns(positions, radius, height) {
    union() {
        // A column at each hole position
        for (p = positions) {
            translate([p[0], p[1], 0])
                cylinder(r=radius, h=height, center=false, $fn=50);
        }
    }
}

module block_base(thickness, padding, positions) {
    // X-axis
    left = positions[1][0];
    right = positions[0][0];
    // Y-axis
    forward = positions[0][1];
    backwards = positions[3][1];

    // middle y
    mid = positions[2][1];

    hyp = sqrt(pow(right - left, 2) + pow(forward - backwards, 2));

    difference() {
        span_cube([left - padding, right + padding], [forward + padding, backwards - padding], [0, thickness]);
        translate([left - padding, backwards - padding, 0])
            rotate([0, 0, 45])
                cube(size=[hyp, hyp, thickness * 10], center=true);
    }
}

module underside() {
    union() {
        zmove(underside_thickness() - bind)
            columns(mounting_block_holes(), column_radius(), mounting_block_column_height());
        block_base(underside_thickness(), mounting_block_hole_padding(), mounting_block_holes());
    }
}

module underside_left_stl() {
    stl("underside_left");
    underside();
}

module underside_right_stl() {
    stl("underside_right");
    mirror([1, 0, 0])
        underside();
}

module fastener() {
    top = fastener_thickness();
    padding = mounting_block_hole_padding();
    positions = mounting_block_holes();

    right = positions[0][0];
    forward = positions[0][1];
    backwards = positions[3][1];
    mid = positions[2][0];

    union() {
        difference() {
            block_base(top, padding, positions);
            zmove(-bind) columns(mounting_block_holes(), column_radius(), mounting_block_column_height());
            // # span_cube([mid, right + padding + bind], [forward + padding + bind, backwards - padding - bind], [top-10, top+bind]);
        }
        translate([right + padding - bind, 0, top/2])
           rotate([90, 0, 90])
               rail(top, 10, 10);
    }
}

module fastener_left_stl() {
    stl("fastener_left");
    fastener();
}

module fastener_right_stl() {
    stl("fastener_right");
    mirror([1, 0, 0])
        fastener();
}

module left_block_assembly() {
assembly("left_block") {
    render()
        underside_left_stl();
        z_offset = deco_thickness();
        translate([0, 0, z_offset])
            fastener_left_stl();
}
}

module right_block_assembly() {
assembly("right_block") {
    render()
        underside_right_stl();
        z_offset = deco_thickness();
        translate([0, 0, z_offset])
            fastener_right_stl();
}
}
