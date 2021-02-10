include <NopSCADlib/core.scad>

include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/sliders.scad>
use <BOSL/transforms.scad>

include <./blocks-spec.scad>

include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pcb.scad>

BOARD_TYPE = RPI3;
board_size = pcb_size(BOARD_TYPE);

// clearance between the board and the enclosure wall
clearance = 3;
// shell thickness around the board
enclouse_thickness = 10;

// Pi placement offset
slider_offset = 10;

top_rim_height = 10;
battery_cavity_height = 10;
spacing = 4;
base_block_height = battery_cavity_height + spacing + top_rim_height;

pi_rest_z_offset = battery_cavity_height + spacing;

bind = 0.01;

module dual_slider(base) {
    union() {
        ymove(base)
            slider(l=10, base=base, wall=4, slop=0.2, orient=ORIENT_Z);
        ymove(-base)
            zrot(180)
                slider(l=10, base=base, wall=4, slop=0.2, orient=ORIENT_Z);
    }
}

// The block that sits the PI and houses the battery
// Plus the sliders that connect to the mounting points
module base_block(l, w, h, slider_offset) {
    union() {
        span_cube([-l/2, l/2], [-w/2, w/2], [0, h]);
        xmove(slider_offset)
            dual_slider(75);
    }
}

module pi_base(dim) {
    // interior sizes
    il = dim[0] + clearance;
    iw = dim[1] + clearance;
    ih = dim[2];
    // exterior sizes
    el = il + enclouse_thickness;
    ew = iw + enclouse_thickness;
    eh = ih + enclouse_thickness;

    // difference() {
    //     // Exterior
    //     union() {
    //         // xmove(pi_placement_offset)
    //         span_cube([-el/2, el/2], [-ew/2, ew/2], [0, eh]);
    //         xmove(slider_offset)
    //             dual_slider(75);
    //     }
    //     // Cut out by interior
    //     span_cube([-il/2, il/2], [-iw/2, iw/2], [ih, eh + 100]);
    //     // Cut out by ports
    //     pcb_cutouts(BOARD_TYPE);
    // }

    // base_block_height = eh + battery_cavity_height;
    difference() {
        base_block(el, ew, base_block_height, slider_offset);
        span_cube([-il/2, el/2 + bind], [-iw/2, iw/2], [0, battery_cavity_height]);
        span_cube([-il/2, il/2], [-iw/2, iw/2], [battery_cavity_height + spacing, eh + 100]);
        zmove(pi_rest_z_offset)
            pcb_cutouts(BOARD_TYPE);
    }
}

module pi_mount() {
    pi_base(board_size);
}

module pi_mount_stl() {
    stl("pi_mount");
    pi_mount();
}

module pi_mount_assembly() {
assembly("pi_mount_assembly") {
    render()
        pi_mount_stl();
        zmove(pi_rest_z_offset) pcb(BOARD_TYPE);
}
}
