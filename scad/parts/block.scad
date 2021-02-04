include <../NopSCADlib/lib.scad>

// Two pieces.
// The underside, which has columns that come through the cover mounting holes
// The fastener side that mates with the columns. The fastener will have inserts for 
// machine screws
include <../vitamins/deco-cover-spec.scad>

padding = 10;
hole_group_length_x = deco_mounting_holes_length_x();
// The block will be large enough to cover the mounting holes
underside_length = hole_group_length_x + padding;
underside_width = deco_mounting_holes_length_y() + padding;
underside_thickness = 2;

// How long the columns must be
column_height = 20;

fastener_length = underside_length;
fastener_width = underside_width;
fastener_thickness = column_height + 5;

bind = 0.01;

// TODO: Configurable radius
module columns() {
    union() {
        // A column at each hole position
        for (p = deco_mounting_holes()) {
            translate([p[0], p[1], 0])
                cylinder(r=deco_mounting_hole_radius(), h=column_height, center=false, $fn=50);
        }
    }
}

module underside(x_trans) {
    union() {
        center_offset = [-underside_length / 2, -underside_width / 2];
        translate([center_offset[0] + x_trans, center_offset[1], 0])
            block_base(underside_length, underside_width, underside_thickness);
        // Translated up to the top surface of the block
        // Translate to the side by half the length to center the column group
        translate([0, 0, underside_thickness / 2 - bind])
            rotate([0, 0])
                columns();
    }
}

module underside_left_stl() {
    stl("underside_left");
    underside(-hole_group_length_x / 2);
}

module underside_right_stl() {
    stl("underside_right");
    mirror([1, 0, 0])
        underside(-hole_group_length_x / 2);
}

module fastener() {
    center_offset = [-fastener_length / 2, -fastener_width / 2];

    difference() {
        translate([center_offset[0], center_offset[1], 0])
            block_base(fastener_length, fastener_width, fastener_thickness);
        translate([hole_group_length_x / 2, 0, (fastener_thickness / 2) - column_height + bind])
            columns();
    }

}

// A block with angled corner
module block_base(l, w, t) {
    rotate([0, 0, 0])
        difference() {
            cube(size=[l, w, t]);
            rotate([0, 0, 45])
                translate([-l/2, -w/2, -bind])
                    cube(size=[l, w, t + 2*bind]);
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
