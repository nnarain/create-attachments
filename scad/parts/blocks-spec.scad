include <../vitamins/deco-cover-spec.scad>

_column_height = 4;

mounting_block_spec = [
    // Deco cover mounting holes                   (0)
    deco_mounting_holes(),
    // Padding bettwen the mounting holes and the edge of the block
    10,
    // Column height
    _column_height,
    // Column radius
    deco_mounting_hole_radius() * 0.90,
    // Underside thickness
    1.5,
    // Fastener thickness
    _column_height + 10,
    // Cable wrap height
    30,
    // cable wrap radius
    7.5,
    // cable wrap depth
    5,
    // cable wrap offset
    deco_mounting_holes()[1][0] / 2,
];

function mounting_block_holes() = mounting_block_spec[0];
function mounting_block_hole_padding() = mounting_block_spec[1];
function mounting_block_column_height() = mounting_block_spec[2];
function column_radius() = mounting_block_spec[3];
function fastener_thickness() = mounting_block_spec[5];
function cable_wrap_height() = mounting_block_spec[6];
function cable_wrap_radius() = mounting_block_spec[7];
function cable_wrap_depth() = mounting_block_spec[8];
function cable_wrap_offset() = mounting_block_spec[9];
