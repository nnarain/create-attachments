include <NopSCADlib/lib.scad>
include <BOSL/constants.scad>
use <BOSL/shapes.scad>

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

fastener_length = underside_length;
fastener_width = underside_width;
fastener_thickness = column_height + 10;
fastener_mounting_hole_radius = deco_mounting_hole_radius();
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

module block_base(thickness) {
    mounting_hole_positions = mounting_block_holes();
    padding = mounting_block_hole_padding();

    // X-axis
    left = mounting_hole_positions[1][0];
    right = mounting_hole_positions[0][0];
    // Y-axis
    forward = mounting_hole_positions[0][1];
    backwards = mounting_hole_positions[3][1];

    // middle y
    mid = mounting_hole_positions[2][1];

    hyp = sqrt(pow(right - left, 2) + pow(forward - backwards, 2));

    difference() {
        span_cube([left - padding, right + padding], [forward + padding, backwards - padding], [0, thickness]);
        translate([left - padding, backwards - padding, 0])
            rotate([0, 0, 45])
                cube(size=[hyp, hyp, 10], center=true);
    }
}

module underside() {
    union() {
        columns(mounting_block_holes(), deco_mounting_hole_radius(), mounting_block_column_height());
        block_base(underside_thickness());
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
    // cube(size=[10, 10, 10], center=true);
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
assembly("left_block_assembly") {
    render()
        underside_left_stl();
        z_offset = underside_thickness + deco_thickness();
        translate([-hole_group_length_x / 2, 0, z_offset])
            fastener_left_stl();
}
}

module right_block_assembly() {
assembly("right_block_assembly") {
    render()
        underside_right_stl();
        z_offset = underside_thickness + deco_thickness();
        translate([hole_group_length_x / 2, 0, z_offset])
            fastener_right_stl();
}
}
