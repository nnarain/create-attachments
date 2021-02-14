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

module fastener() {
    top = fastener_thickness();
    padding = mounting_block_hole_padding();
    positions = mounting_block_holes();

    left = positions[1][0];
    right = positions[0][0];
    forward = positions[0][1];
    backwards = positions[3][1];
    mid = positions[2][0];

    union() {
        difference() {
            block_base(top, padding, positions);
            // A column for the serial cable to wrap around
            // translate([cable_wrap_offset(), 0, top - cable_wrap_depth()])
            //     cylinder(r=cable_wrap_radius(), h=cable_wrap_height(), center=false);
        }
        height = mounting_block_column_height();
        zmove(-height + bind) columns(mounting_block_holes(), column_radius(), height);
        translate([right + padding - bind, 0, top/2])
           rotate([90, 0, 90])
               rail(top, 10, 10);
    }
}

module cable_wrap_stl() {
    stl("cable_wrap");
    cylinder(r=cable_wrap_radius(), h=cable_wrap_height(), center=false);
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
        fastener_left_stl();
        // translate([cable_wrap_offset(), 0, 0])
        //     cable_wrap_stl();
}
}

module right_block_assembly() {
assembly("right_block") {
    render()
        fastener_right_stl();
        // translate([-cable_wrap_offset(), 0, 0])
        //     cable_wrap_stl();
}
}