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
clearance = [6, 3];
// shell thickness around the board
enclouse_thickness = 7.5;

top_rim_height = 4.5;
spacing = 4;
base_block_height = spacing + top_rim_height;

pi_rest_z_offset = spacing;

bind = 0.01;

// The block that sits the PI and houses the battery
// Plus the sliders that connect to the mounting points
module base_block(l, w, h) {
    span_cube([-l/2, l/2], [-w/2, w/2], [0, h]);
}

module pi_base(dim) {
    // interior sizes
    il = dim[0] + clearance[0];
    iw = dim[1] + clearance[1];
    ih = dim[2];
    // exterior sizes
    el = il + enclouse_thickness;
    ew = iw + enclouse_thickness;
    eh = ih + enclouse_thickness;

    difference() {
        base_block(el, ew, base_block_height);
        span_cube([-il/2, il/2], [-iw/2, iw/2], [spacing, eh + 100]);
        zmove(pi_rest_z_offset)
            pcb_cutouts(BOARD_TYPE);
    }
}

module pi_mount() {
    pi_base(board_size);
}
